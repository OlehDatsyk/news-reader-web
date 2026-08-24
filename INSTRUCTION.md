# 🧭 INSTRUCTION.md - Complete Beginner's Setup & Usage Guide

## News Reader - V2 (Web)

This guide assumes you have **never used** Python, Git, Visual Studio Code,
a terminal, virtual environments, or an API before. Every step is spelled
out - just follow them in order from top to bottom. Skipping a step is the
#1 cause of "it doesn't work" problems, so please don't skip any.

> ⏱️ Total time for a first-time setup: roughly 15-25 minutes.

---

## Table of Contents

1. [What You're Installing and Why](#1-what-youre-installing-and-why)
2. [Install Python](#2-install-python)
3. [Install Git](#3-install-git)
4. [Install Visual Studio Code](#4-install-visual-studio-code)
5. [Install the Recommended VS Code Extensions](#5-install-the-recommended-vs-code-extensions)
6. [Open the Project in VS Code](#6-open-the-project-in-vs-code)
7. [Create a Virtual Environment](#7-create-a-virtual-environment)
8. [Activate the Virtual Environment](#8-activate-the-virtual-environment)
9. [Install the Project's Dependencies](#9-install-the-projects-dependencies)
10. [Create Your .env File](#10-create-your-env-file)
11. [Get Your NewsAPI Key](#11-get-your-newsapi-key)
12. [Run the Application](#12-run-the-application)
13. [Test That Everything Works](#13-test-that-everything-works)
14. [Using Every Feature of the App](#14-using-every-feature-of-the-app)
15. [Stopping the App / Running It Again Later](#15-stopping-the-app--running-it-again-later)
16. [Troubleshooting](#16-troubleshooting)
17. [FAQ](#17-faq)
18. [Common Mistakes Beginners Make](#18-common-mistakes-beginners-make)
19. [Security Recommendations](#19-security-recommendations)
20. [Next Learning Steps](#20-next-learning-steps)

---

## 1. What You're Installing and Why

| Tool | What it is | Why you need it |
|---|---|---|
| **Python** | The programming language this app is written in | Runs the Flask backend (`app.py`) |
| **Git** (optional) | A tool for tracking code changes / downloading projects | Only needed if you clone this project from GitHub instead of downloading a ZIP |
| **Visual Studio Code (VS Code)** | A code editor | Lets you open, read, and run the project's files with a built-in terminal |
| **Virtual environment** | An isolated Python "sandbox" for this project only | Keeps this project's packages separate from every other Python project on your computer |
| **NewsAPI key** | A free access token from newsapi.org | Lets the app fetch real news articles |

---

## 2. Install Python

1. Go to **https://www.python.org/downloads/**
2. Click the big **"Download Python 3.x.x"** button (any version 3.10 or newer works).
3. Run the installer.
   - **Windows:** On the very first installer screen, tick the checkbox
     **"Add python.exe to PATH"** at the bottom before clicking "Install Now".
     This step is the single most common thing people forget - don't skip it.
   - **macOS:** Run the `.pkg` installer and click Continue/Agree/Install
     through the prompts.
4. When it finishes, confirm the install worked:
   - **Windows:** Press `Start`, type `cmd`, open **Command Prompt**, type:
     ```
     python --version
     ```
   - **macOS:** Open **Terminal** (press `Cmd + Space`, type "Terminal", hit
     Enter), type:
     ```
     python3 --version
     ```
   You should see something like `Python 3.12.4`. If you see an error, revisit
   step 3 (the PATH checkbox on Windows is almost always the cause).

---

## 3. Install Git

Git is **optional** - only needed if you plan to `git clone` this project
from GitHub. If you already have the project as a folder or ZIP file, you
can skip to [Section 4](#4-install-visual-studio-code).

1. Go to **https://git-scm.com/downloads**
2. Download the installer for your operating system.
3. Run it and click "Next" through the default options (the defaults are
   fine for beginners).
4. Confirm it worked by opening a terminal (Command Prompt on Windows,
   Terminal on macOS) and typing:
   ```
   git --version
   ```

---

## 4. Install Visual Studio Code

1. Go to **https://code.visualstudio.com/**
2. Click **Download**, then run the installer.
3. On Windows, during installation, it's helpful to tick **"Add to PATH"**
   and **"Add 'Open with Code' action"** if offered.
4. Open VS Code once to confirm it launches.

---

## 5. Install the Recommended VS Code Extensions

Inside VS Code:

1. Click the **Extensions** icon in the left sidebar (it looks like four
   small squares, or press `Ctrl+Shift+X` / `Cmd+Shift+X`).
2. Search for and install:
   - **Python** (by Microsoft) - enables Python syntax highlighting, linting,
     and lets VS Code find your virtual environment automatically.
3. That's the only extension required to work comfortably with this project.

---

## 6. Open the Project in VS Code

1. Unzip the project folder (`news-reader-web`) somewhere easy to find, like
   your Desktop or Documents folder.
2. Open VS Code.
3. Go to **File -> Open Folder...** (macOS: **File -> Open...**).
4. Select the `news-reader-web` folder and click **Select Folder** / **Open**.
5. You should now see the file list on the left: `app.py`, `templates/`,
   `static/`, `requirements.txt`, etc.
6. Open the built-in terminal: **Terminal -> New Terminal** (or
   `` Ctrl+` ``). All the following commands are typed into this terminal,
   **from inside the `news-reader-web` folder**.

---

## 7. Create a Virtual Environment

A virtual environment keeps this project's Python packages separate from
everything else on your computer. In the VS Code terminal, run:

**Windows:**
```
python -m venv venv
```

**macOS:**
```
python3 -m venv venv
```

This creates a new folder called `venv/` inside your project. That folder
is intentionally excluded from Git via `.gitignore`, so it will never be
uploaded to GitHub - that's expected and correct.

---

## 8. Activate the Virtual Environment

You must activate the virtual environment **every time** you open a new
terminal to work on this project.

**Windows (Command Prompt):**
```
venv\Scripts\activate
```

**Windows (PowerShell):**
```
venv\Scripts\Activate.ps1
```
> If PowerShell blocks the script with a "running scripts is disabled" error,
> run this once: `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned`, then
> try activating again.

**macOS / Linux (bash/zsh Terminal):**
```
source venv/bin/activate
```

You'll know it worked because your terminal prompt will now start with
`(venv)`.

---

## 9. Install the Project's Dependencies

With the virtual environment **activated**, run:

```
pip install -r requirements.txt
```

This installs the three packages the app needs: **Flask** (the web
framework), **requests** (for calling the NewsAPI), and **python-dotenv**
(for reading the `.env` file). You'll see download/install progress in the
terminal - wait until it finishes with no red error text.

---

## 10. Create Your `.env` File

1. In the VS Code file list, find `.env.example`.
2. Make a copy of it and rename the copy to exactly `.env` (no ".example",
   and note the leading dot - there is no filename before the dot).
   - Easiest way: right-click `.env.example` -> **Copy**, then right-click
     the folder -> **Paste**, then rename the new file to `.env`.
3. Open `.env` and you'll see:
   ```
   NEWS_API_KEY=your_key_here
   NEWS_API_COUNTRY=us
   ```
4. Replace the key value with your **own** NewsAPI key (next section shows
   you how to get one). Never share this file or commit it to GitHub - it's
   already listed in `.gitignore` so Git will ignore it automatically.

---

## 11. Get Your NewsAPI Key

1. Go to **https://newsapi.org/register**
2. Fill in the free signup form (name, email, password) and submit.
3. After registering, you'll land on your account dashboard, or you can go
   to **https://newsapi.org/account**.
4. Copy the **API key** shown there (a long string of letters and numbers).
5. Paste it into your `.env` file as the value of `NEWS_API_KEY`, for example:
   ```
   NEWS_API_KEY=abcd1234yourrealkeygoeshere
   ```
6. Save the file (`Ctrl+S` / `Cmd+S`).

> ⚠️ **Important:** This project's source code currently contains a
> hardcoded fallback key. See **Section 19 (Security Recommendations)** and
> `PROJECT_REVIEW.md` - you should still set your own key in `.env` and
> treat the built-in fallback key as compromised/unsafe to rely on.

---

## 12. Run the Application

With the virtual environment activated and dependencies installed, run:

```
python app.py
```

You should see output similar to:
```
 * Running on http://127.0.0.1:8000
```

Leave this terminal window open - the app keeps running as long as this
process is active. Closing the terminal or pressing `Ctrl+C` stops the app.

---

## 13. Test That Everything Works

1. Open your web browser.
2. Go to: **http://127.0.0.1:8000**
3. You should see the News Reader interface load with news article cards.
4. As an extra check, visit **http://127.0.0.1:8000/health** - you should
   see JSON like `{"status": "ok", "api_key_configured": true}`. If
   `api_key_configured` is `false`, your `.env` file isn't set up correctly
   - revisit Section 10.

---

## 14. Using Every Feature of the App

- **Category filters** - Click any pill at the top (General, Business,
  Entertainment, Health, Science, Sports, Technology) to load headlines from
  that category.
- **Search bar** - Type any keyword (e.g. "climate", "football") to search
  across all articles. Searching automatically overrides the category
  filter. There's a short typing delay (debounce) before it searches, so you
  don't need to press Enter.
- **Clear search (✕ button)** - Clears the search box and returns to
  browsing by category.
- **Infinite scroll** - Keep scrolling down and more articles load
  automatically. When there are no more results, you'll see "🎉 You've
  reached the end of the feed."
- **Dark mode toggle (🌙 / ☀️ icon)** - Switches between light and dark
  themes. Your choice is remembered the next time you open the app.
- **Read Article button** - Opens the original article on its source
  website in a new browser tab.

---

## 15. Stopping the App / Running It Again Later

**To stop the app:** Click into its terminal window and press `Ctrl+C`.

**To run it again later** (after closing VS Code or restarting your
computer), you do **not** need to repeat every step - just:

1. Open the project folder in VS Code.
2. Open a terminal.
3. Activate the virtual environment (Section 8).
4. Run `python app.py` (Windows) or `python3 app.py` (macOS).

Or simply double-click **`Start App.bat`** (Windows) or
**`Start App (Mac).command`** (macOS) - these scripts do all of the above
for you automatically.

---

## 16. Troubleshooting

| Problem | Likely Cause | Fix |
|---|---|---|
| `'python' is not recognized as an internal or external command` | Python wasn't added to PATH | Reinstall Python and tick "Add python.exe to PATH" (Section 2) |
| `ModuleNotFoundError: No module named 'flask'` | Dependencies not installed, or venv not activated | Activate the venv (Section 8), then re-run `pip install -r requirements.txt` |
| Browser shows "This site can't be reached" | The app isn't running, or you closed its terminal | Re-run `python app.py` and keep the terminal open |
| App loads but shows "Server is missing a NEWS_API_KEY" | `.env` file missing or empty | Redo Section 10 - make sure the file is named exactly `.env` |
| App loads but articles fail with a provider error message | Invalid, expired, or rate-limited NewsAPI key | Get a fresh key at newsapi.org/account and update `.env` |
| PowerShell won't let you activate the venv | Script execution is disabled | Run `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned` once, then retry |
| Port 8000 already in use | Another program (or a previous run) is using port 8000 | Close the other program, or edit the `port=8000` line in `app.py` to a free port like `5050` |
| Changes to code don't show up in the browser | Old page is cached, or app wasn't restarted | Hard-refresh the browser (`Ctrl+Shift+R` / `Cmd+Shift+R`); restart `python app.py` |

---

## 17. FAQ

**Do I need to know how to code to run this?**
No. Following this guide step by step is enough to run it. You only need
coding knowledge if you want to *modify* the app.

**Do I need to keep the terminal open while using the app?**
Yes. The terminal running `python app.py` **is** the server. Closing it
stops the app.

**Is my NewsAPI key safe?**
It stays in your local `.env` file and is never sent to the browser - the
Flask backend acts as a proxy. Just make sure you never commit `.env` to
GitHub (it's already excluded via `.gitignore`).

**Can I use this app without an internet connection?**
No - it needs internet access to reach NewsAPI.org.

**Why do I need a virtual environment?**
So this project's Python packages don't conflict with other projects on
your machine. It's a best practice, not a hard technical requirement.

**Can I deploy this online for others to use?**
Yes, but first read Section 19 (Security) - in particular, remove the
hardcoded fallback API key and disable debug mode before deploying anywhere
public.

---

## 18. Common Mistakes Beginners Make

- Forgetting to tick "Add python.exe to PATH" during Python install (Windows).
- Running `pip install` **before** activating the virtual environment (the
  packages install to the wrong place).
- Naming the file `.env.txt` instead of `.env` (some operating systems
  hide file extensions - make sure "File name extensions" is visible in
  File Explorer, or use VS Code's file list to rename it).
- Forgetting to keep the terminal window open while using the app.
- Copying the API key with extra spaces or quotation marks around it.
- Editing `.env.example` instead of the new `.env` file.
- Trying to open `index.html` directly by double-clicking it - this project
  **must** be run through `python app.py` and viewed via
  `http://127.0.0.1:8000`, not by opening the HTML file directly.

---

## 19. Security Recommendations

- **Never commit your `.env` file to GitHub.** It's already listed in
  `.gitignore`, but always double-check before pushing.
- **Rotate the NewsAPI key found hardcoded in `app.py` and
  `.env.example`.** A real-looking key is currently used as a fallback
  default value directly in the source code (not just as an example
  placeholder). Treat that specific key as exposed: request a new one from
  your NewsAPI account and use only your own key in your local `.env` file.
  See `PROJECT_REVIEW.md` for full details.
- **Turn off debug mode before deploying publicly.** `app.py` currently
  runs with `debug=True`, which is meant only for local development - it can
  leak internal details in error pages if exposed to the internet.
- **Don't share your `.env` file** with anyone, in screenshots, or in chat
  messages.
- If you ever accidentally commit a real API key to GitHub, **rotate
  (regenerate) that key immediately** on newsapi.org - deleting the commit
  alone is not enough, since it may already be cached or scraped.

---

## 20. Next Learning Steps

Once you're comfortable running this project, here's a natural learning
path:

1. **Learn basic Python** - freeCodeCamp, Python.org's official tutorial, or
   "Automate the Boring Stuff with Python" (free online).
2. **Learn Flask basics** - Flask's official quickstart guide
   (https://flask.palletsprojects.com/) to understand `app.py`.
3. **Learn Git & GitHub** - how to `git init`, `git add`, `git commit`, and
   push a repository, so you can version-control and share your own
   projects.
4. **Learn about environment variables and `.env` files** - why secrets
   should never be hardcoded in source code.
5. **Try adding a feature** - e.g., a "bookmark article" button using
   browser `localStorage`, or a "read time estimate" on each card, as a
   hands-on way to practice editing `script.js` and `app.py`.

You now have everything you need to run, use, and start learning from this
project. 🎉
