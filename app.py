"""
News Reader — V2 (Web)
=======================
A Flask backend that powers a modern, responsive news reading web app.

It exposes a single JSON API endpoint (/api/news) that the frontend
(templates/index.html + static/js/script.js) calls to fetch articles from
NewsAPI.org (https://newsapi.org). The backend acts as a small proxy so
that the API key is never exposed to the browser.

Author: Generated for "News Reader — V2 (Web)"
"""

import os
from datetime import datetime

import requests
from dotenv import load_dotenv
from flask import Flask, jsonify, render_template, request

# ---------------------------------------------------------------------------
# App & configuration setup
# ---------------------------------------------------------------------------

# Load variables from the .env file (NEWS_API_KEY, etc.) into the environment
load_dotenv()

app = Flask(__name__)

NEWS_API_KEY = os.getenv("NEWS_API_KEY", "").strip()
NEWS_API_BASE_URL = "https://newsapi.org/v2"

# Categories supported by NewsAPI's "top-headlines" endpoint
VALID_CATEGORIES = {
    "general",
    "business",
    "entertainment",
    "health",
    "science",
    "sports",
    "technology",
}

# Default country used for the "top-headlines" endpoint when no search
# keyword is provided. NewsAPI requires a country (or sources) parameter
# for that endpoint.
DEFAULT_COUNTRY = os.getenv("NEWS_API_COUNTRY", "us")

# A small fallback image used on the frontend when an article has no image.
PLACEHOLDER_IMAGE = "/static/img/placeholder.svg"


# ---------------------------------------------------------------------------
# Helper functions
# ---------------------------------------------------------------------------

def _error_response(message, status_code=400):
    """Return a standardized JSON error response."""
    return jsonify({"status": "error", "message": message, "articles": []}), status_code


def _normalize_article(raw):
    """
    Convert a raw NewsAPI article object into the simplified shape used by
    the frontend. Keeping this logic in one place makes it easy to swap
    out the news provider later without touching the JavaScript.
    """
    published_at = raw.get("publishedAt")
    formatted_date = published_at
    if published_at:
        try:
            dt = datetime.strptime(published_at, "%Y-%m-%dT%H:%M:%SZ")
            formatted_date = dt.strftime("%B %d, %Y • %I:%M %p")
        except (ValueError, TypeError):
            formatted_date = published_at

    source_name = "Unknown Source"
    if isinstance(raw.get("source"), dict):
        source_name = raw["source"].get("name") or source_name

    return {
        "title": raw.get("title") or "Untitled Article",
        "description": raw.get("description") or "No description available for this article.",
        "url": raw.get("url"),
        "image": raw.get("urlToImage") or PLACEHOLDER_IMAGE,
        "source": source_name,
        "author": raw.get("author") or "Unknown Author",
        "publishedAt": formatted_date,
        "publishedAtRaw": published_at,
    }


# ---------------------------------------------------------------------------
# Routes
# ---------------------------------------------------------------------------

@app.route("/")
def index():
    """Render the single-page application shell."""
    return render_template("index.html", categories=sorted(VALID_CATEGORIES))


@app.route("/api/news")
def api_news():
    """
    JSON API used by the frontend to fetch news articles.

    Query parameters:
        category  (str)  optional, one of VALID_CATEGORIES. Ignored if a
                          search keyword is provided (NewsAPI's "everything"
                          endpoint does not support category filtering).
        query     (str)  optional search keyword.
        page      (int)  page number for infinite scrolling. Defaults to 1.
        page_size (int)  number of articles per page. Defaults to 12, max 50.
    """
    if not NEWS_API_KEY:
        return _error_response(
            "Server is missing a NEWS_API_KEY. Add it to your .env file. "
            "See README.md for instructions on how to obtain one.",
            status_code=500,
        )

    category = (request.args.get("category") or "").strip().lower()
    query = (request.args.get("query") or "").strip()

    try:
        page = max(1, int(request.args.get("page", 1)))
    except ValueError:
        page = 1

    try:
        page_size = int(request.args.get("page_size", 12))
    except ValueError:
        page_size = 12
    page_size = max(1, min(page_size, 50))

    params = {
        "apiKey": NEWS_API_KEY,
        "page": page,
        "pageSize": page_size,
        "language": "en",
    }

    if query:
        # Keyword search uses the "everything" endpoint so we can search
        # across all articles, regardless of category.
        endpoint = f"{NEWS_API_BASE_URL}/everything"
        params["q"] = query
        params["sortBy"] = "publishedAt"
    else:
        # No keyword: browse by category using "top-headlines".
        endpoint = f"{NEWS_API_BASE_URL}/top-headlines"
        params["country"] = DEFAULT_COUNTRY
        if category and category in VALID_CATEGORIES and category != "general":
            params["category"] = category
        elif category == "general":
            params["category"] = "general"

    try:
        response = requests.get(endpoint, params=params, timeout=10)
    except requests.exceptions.RequestException as exc:
        return _error_response(f"Could not reach the news provider: {exc}", status_code=502)

    if response.status_code != 200:
        try:
            provider_message = response.json().get("message", "Unknown error from news provider.")
        except ValueError:
            provider_message = "Unknown error from news provider."
        return _error_response(provider_message, status_code=response.status_code)

    data = response.json()
    raw_articles = data.get("articles", [])
    articles = [_normalize_article(a) for a in raw_articles]

    total_results = data.get("totalResults", len(articles))
    has_more = page * page_size < total_results

    return jsonify(
        {
            "status": "ok",
            "page": page,
            "page_size": page_size,
            "total_results": total_results,
            "has_more": has_more,
            "articles": articles,
        }
    )


@app.route("/health")
def health():
    """Simple health check endpoint (useful for debugging deployment)."""
    return jsonify({"status": "ok", "api_key_configured": bool(NEWS_API_KEY)})


# ---------------------------------------------------------------------------
# Entry point
# ---------------------------------------------------------------------------

if __name__ == "__main__":
    # debug=True gives auto-reload and detailed error pages during
    # development. Turn this off (debug=False) before deploying anywhere
    # public.
    app.run(debug=True, host="127.0.0.1", port=5000)
