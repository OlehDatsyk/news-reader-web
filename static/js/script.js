/* =========================================================
   News Reader — V2 — Frontend logic
   Handles: category filtering, keyword search, infinite
   scrolling, dark mode toggle, and rendering news cards.
   ========================================================= */

(() => {
  "use strict";

  // ----------------------------- DOM references -----------------------------
  const newsGrid = document.getElementById("newsGrid");
  const loadingIndicator = document.getElementById("loadingIndicator");
  const scrollSentinel = document.getElementById("scrollSentinel");
  const endOfResults = document.getElementById("endOfResults");
  const emptyState = document.getElementById("emptyState");
  const statusBanner = document.getElementById("statusBanner");
  const searchInput = document.getElementById("searchInput");
  const searchClear = document.getElementById("searchClear");
  const categoryBar = document.getElementById("categoryBar");
  const darkModeToggle = document.getElementById("darkModeToggle");
  const darkModeIcon = document.getElementById("darkModeIcon");
  const cardTemplate = document.getElementById("newsCardTemplate");

  // ----------------------------- App state -----------------------------
  const state = {
    category: "general",
    query: "",
    page: 1,
    pageSize: 12,
    isLoading: false,
    hasMore: true,
  };

  let debounceTimer = null;
  let observer = null;

  // ----------------------------- Dark mode -----------------------------
  function initDarkMode() {
    const saved = localStorage.getItem("newsReaderTheme");
    const prefersDark = window.matchMedia("(prefers-color-scheme: dark)").matches;
    const theme = saved || (prefersDark ? "dark" : "light");
    applyTheme(theme);
  }

  function applyTheme(theme) {
    if (theme === "dark") {
      document.documentElement.setAttribute("data-theme", "dark");
      darkModeIcon.textContent = "☀️";
    } else {
      document.documentElement.removeAttribute("data-theme");
      darkModeIcon.textContent = "🌙";
    }
    localStorage.setItem("newsReaderTheme", theme);
  }

  darkModeToggle.addEventListener("click", () => {
    const isDark = document.documentElement.getAttribute("data-theme") === "dark";
    applyTheme(isDark ? "light" : "dark");
  });

  // ----------------------------- Category filter -----------------------------
  categoryBar.addEventListener("click", (event) => {
    const btn = event.target.closest(".category-btn");
    if (!btn) return;

    document.querySelectorAll(".category-btn").forEach((b) => b.classList.remove("active"));
    btn.classList.add("active");

    state.category = btn.dataset.category;
    state.query = "";
    searchInput.value = "";
    searchClear.classList.remove("visible");

    resetAndLoad();
  });

  // ----------------------------- Search -----------------------------
  searchInput.addEventListener("input", () => {
    searchClear.classList.toggle("visible", searchInput.value.trim().length > 0);

    clearTimeout(debounceTimer);
    debounceTimer = setTimeout(() => {
      state.query = searchInput.value.trim();
      resetAndLoad();
    }, 450); // debounce so we don't hammer the API on every keystroke
  });

  searchClear.addEventListener("click", () => {
    searchInput.value = "";
    searchClear.classList.remove("visible");
    state.query = "";
    resetAndLoad();
  });

  // ----------------------------- Fetching & rendering -----------------------------

  function resetAndLoad() {
    state.page = 1;
    state.hasMore = true;
    newsGrid.innerHTML = "";
    hide(endOfResults);
    hide(emptyState);
    hide(statusBanner);
    loadNews();
  }

  async function loadNews() {
    if (state.isLoading || !state.hasMore) return;

    state.isLoading = true;
    show(loadingIndicator);
    hide(statusBanner);

    const params = new URLSearchParams({
      page: state.page,
      page_size: state.pageSize,
    });

    if (state.query) {
      params.set("query", state.query);
    } else {
      params.set("category", state.category);
    }

    try {
      const response = await fetch(`/api/news?${params.toString()}`);
      const data = await response.json();

      if (!response.ok || data.status !== "ok") {
        showError(data.message || "Something went wrong while fetching news.");
        state.hasMore = false;
        return;
      }

      if (data.articles.length === 0 && state.page === 1) {
        show(emptyState);
      }

      renderArticles(data.articles);

      state.hasMore = Boolean(data.has_more);
      state.page += 1;

      if (!state.hasMore && data.articles.length > 0) {
        show(endOfResults);
      }
    } catch (err) {
      showError("Network error: could not reach the server. Is the Flask app running?");
      state.hasMore = false;
    } finally {
      state.isLoading = false;
      hide(loadingIndicator);
    }
  }

  function renderArticles(articles) {
    const fragment = document.createDocumentFragment();

    articles.forEach((article) => {
      const node = cardTemplate.content.cloneNode(true);

      const img = node.querySelector(".card-image");
      img.src = article.image;
      img.alt = article.title;
      img.onerror = () => {
        img.src = "/static/img/placeholder.svg";
      };

      node.querySelector(".card-source-badge").textContent = article.source;
      node.querySelector(".card-title").textContent = article.title;
      node.querySelector(".card-description").textContent = article.description;
      node.querySelector(".card-date").textContent = `🗓 ${article.publishedAt || "Unknown date"}`;

      const link = node.querySelector(".card-btn");
      if (article.url) {
        link.href = article.url;
      } else {
        link.style.display = "none";
      }

      fragment.appendChild(node);
    });

    newsGrid.appendChild(fragment);
  }

  function showError(message) {
    statusBanner.textContent = `⚠️ ${message}`;
    show(statusBanner);
  }

  function show(el) {
    el.classList.remove("hidden");
  }

  function hide(el) {
    el.classList.add("hidden");
  }

  // ----------------------------- Infinite scroll -----------------------------
  function initInfiniteScroll() {
    observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            loadNews();
          }
        });
      },
      { root: null, rootMargin: "200px", threshold: 0 }
    );

    observer.observe(scrollSentinel);
  }

  // ----------------------------- Init -----------------------------
  function init() {
    initDarkMode();
    initInfiniteScroll();
    loadNews();
  }

  document.addEventListener("DOMContentLoaded", init);
})();
