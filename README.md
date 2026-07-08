# 📰 News Reader - V2 (Web)

A modern, responsive news reading web application built with **Flask**,
**Python**, **HTML**, **CSS**, and **JavaScript**. It supports category
filtering, keyword search, infinite scrolling, a loading animation, and a
full dark mode.

This README is written for someone who has **never run a Python/Flask
project before** and has only Visual Studio Code installed. Follow every
step in order and you will have the app running in your browser.

---

## Table of Contents

1. [What This Project Does](#1-what-this-project-does)
2. [Project Folder Structure](#2-project-folder-structure)
3. [Prerequisites](#3-prerequisites)
4. [Step 1 - Install Python](#step-1--install-python)
5. [Step 2 - Install Git (Optional)](#step-2--install-git-optional)
6. [Step 3 - Open the Project in VS Code](#step-3--open-the-project-in-vs-code)
7. [Step 4 - Create a Virtual Environment](#step-4--create-a-virtual-environment)
8. [Step 5 - Activate the Virtual Environment](#step-5--activate-the-virtual-environment)
9. [Step 6 - Install Project Dependencies](#step-6--install-project-dependencies)
10. [Step 7 - Get a Free NewsAPI Key](#step-7--get-a-free-newsapi-key)
11. [Step 8 - Set Up the .env File](#step-8--set-up-the-env-file)
12. [Step 9 - Run the Application](#step-9--run-the-application)
13. [Step 10 - Using the App](#step-10--using-the-app)
14. [Common Errors and Solutions](#11-common-errors-and-solutions)
15. [Stopping the Server](#12-stopping-the-server)
16. [Rebuilding / Running Again Later](#13-rebuilding--running-again-later)
17. [Tech Stack Summary](#14-tech-stack-summary)

---

## 1. What This Project Does

News Reader - V2 is a single-page web app that:

- Fetches live news articles from **[NewsAPI.org](https://newsapi.org)**
  through a small Flask backend (so your API key stays private).
- Lets you filter news by category: General, Business, Entertainment,
  Health, Science, Sports, Technology.
- Lets you search for any keyword (e.g. "elections", "AI", "football").
- Loads more articles automatically as you scroll down (**infinite
  scrolling**) instead of using page numbers.
- Shows a loading spinner animation while articles are being fetched.
- Displays each article as a card with an image, title, description,
  source name, publication date, and an **"Read Article"** button that
  opens the original article in a new browser tab.
- Includes a **Dark Mode** toggle that remembers your preference.
- Is fully **responsive** - it works on desktop, tablet, and mobile
  screen sizes.

---

## 2. Project Folder Structure

Once everything is created, your project folder will look like this:

```
news-reader-app/
│
├── app.py                     # Flask backend (routes + NewsAPI proxy)
├── requirements.txt           # Python dependencies
├── .env.example                # Template for your environment variables
├── .env                        # YOU create this - holds your real API key (not committed)
├── .gitignore                  # Tells Git which files to ignore
├── README.md                   # This file
│
├── templates/
│   └── index.html               # Main HTML page (single-page app shell)
│
└── static/
    ├── css/
    │   └── style.css             # All styling, including dark mode & responsiveness
    ├── js/
    │   └── script.js             # Frontend logic: search, filters, infinite scroll
    └── img/
        └── placeholder.svg       # Fallback image for articles with no photo
```

---

## 3. Prerequisites

Before you start, you only need:

- ✅ **Visual Studio Code** installed (you already have this).
- ✅ An internet connection (to download Python packages and fetch news).
- ✅ A free email address (to sign up for a NewsAPI key).

Everything else (Python, virtual environment, dependencies) will be
installed in the steps below.

---

## Step 1 - Install Python

1. Open your web browser and go to **https://www.python.org/downloads/**.
2. Click the yellow **"Download Python 3.x.x"** button (any version 3.10
   or newer works fine).
3. Run the downloaded installer.
   - **Windows:** On the very first installer screen, make sure you
     **check the box that says "Add python.exe to PATH"** at the bottom
     before clicking "Install Now". This step is critical - if you skip
     it, your terminal won't recognize the `python` command.
   - **macOS:** Run the `.pkg` installer and follow the prompts (Next ->
     Next -> Install).
4. Verify the installation. Open **Visual Studio Code**, then open the
   built-in terminal:
   - Menu bar -> **Terminal** -> **New Terminal**
   - Or use the shortcut: `` Ctrl + ` `` (Windows/Linux) or `` Cmd + ` ``
     (macOS)
5. In the terminal, type:

   ```bash
   python --version
   ```

   If you see something like `Python 3.12.4`, Python is installed
   correctly. On some systems (especially macOS/Linux) you may need to
   use `python3` instead of `python`:

   ```bash
   python3 --version
   ```

   > 💡 **Tip:** If neither command works, close and reopen VS Code (and
   > your terminal) after installing Python. This refreshes your PATH
   > environment variable.

---

## Step 2 - Install Git (Optional)

Git is **not required** to run this project if you already have the
project files on your computer (for example, downloaded as a ZIP folder).
You only need Git if you plan to clone this project from a repository
like GitHub.

If you want to install it anyway:

1. Go to **https://git-scm.com/downloads**.
2. Download and run the installer for your operating system, accepting
   the default options.
3. Verify it in the VS Code terminal:

   ```bash
   git --version
   ```

---

## Step 3 - Open the Project in VS Code

1. Make sure all the project files (`app.py`, `templates/`, `static/`,
   etc.) are together inside one folder, e.g. `news-reader-app`.
2. Open VS Code.
3. Go to **File -> Open Folder…** and select the `news-reader-app` folder.
4. VS Code will reload with the project files visible in the **Explorer**
   panel on the left.
5. Open a new terminal inside VS Code (**Terminal -> New Terminal**). This
   terminal automatically starts inside your project folder - you can
   confirm this by typing:

   ```bash
   pwd        # macOS/Linux - prints the current folder path
   ```

   ```powershell
   cd         # Windows PowerShell - prints the current folder path
   ```

   The output should end with `.../news-reader-app`.

---

## Step 4 - Create a Virtual Environment

A **virtual environment** is an isolated folder that keeps this
project's Python packages separate from other projects on your computer.
This avoids version conflicts.

In the VS Code terminal, run:

**Windows:**
```powershell
python -m venv venv
```

**macOS / Linux:**
```bash
python3 -m venv venv
```

This creates a new folder named `venv/` inside your project. You should
now see it appear in the VS Code Explorer sidebar.

> 💡 The `.gitignore` file already excludes `venv/` from version control,
> so you don't need to worry about accidentally uploading it.

---

## Step 5 - Activate the Virtual Environment

You must **activate** the virtual environment every time you open a new
terminal to work on this project.

**Windows (PowerShell - default VS Code terminal):**
```powershell
venv\Scripts\Activate.ps1
```

> ⚠️ If you get an error like *"running scripts is disabled on this
> system"*, run this command once to allow it, then try activating
> again:
> ```powershell
> Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
> ```

**Windows (Command Prompt, if you're using `cmd` instead of PowerShell):**
```cmd
venv\Scripts\activate.bat
```

**macOS / Linux:**
```bash
source venv/bin/activate
```

✅ **How to know it worked:** your terminal prompt will now show
`(venv)` at the beginning, like this:

```
(venv) PS C:\Users\YourName\news-reader-app>
```

or on macOS/Linux:

```
(venv) yourname@MacBook news-reader-app %
```

You will repeat this activation step **every time** you open a new
terminal window for this project. VS Code sometimes activates it
automatically for you and prompts "Select Python Interpreter" - if it
does, choose the interpreter located inside `venv`.

---

## Step 6 - Install Project Dependencies

With the virtual environment **activated** (you see `(venv)` in the
prompt), install all required Python packages listed in
`requirements.txt`:

```bash
pip install -r requirements.txt
```

You should see output similar to:

```
Collecting Flask==3.0.3
  Downloading flask-3.0.3-py3-none-any.whl (101 kB)
Collecting requests==2.32.3
  Downloading requests-2.32.3-py3-none-any.whl (64 kB)
Collecting python-dotenv==1.0.1
  Downloading python_dotenv-1.0.1-py3-none-any.whl (19 kB)
...
Successfully installed Flask-3.0.3 Jinja2-3.1.4 ... requests-2.32.3 python-dotenv-1.0.1 ...
```

This installs:
- **Flask** - the web framework that powers the backend.
- **requests** - used by Flask to call the NewsAPI.org service.
- **python-dotenv** - loads your secret API key from the `.env` file.

---

## Step 7 - Get a Free NewsAPI Key

This app uses **NewsAPI.org** to fetch real news articles. You need a
free API key:

1. Go to **https://newsapi.org/register**.
2. Fill in your name, email address, and a password, then submit the
   form.
3. Verify your email if prompted.
4. After registering/logging in, you'll land on your account page at
   **https://newsapi.org/account**, where you'll see a long string of
   letters and numbers labeled **"API key"**.
5. Copy that key - you'll paste it into the `.env` file in the next
   step.

> 💡 The free "Developer" plan is enough to run and test this app
> locally. Note that the free plan only supports non-commercial,
> local/development use.

---

## Step 8 - Set Up the .env File

The `.env` file stores your secret API key so it never gets hard-coded
into the source files.

1. In the VS Code Explorer, find the file named **`.env.example`**.
2. Make a copy of it and rename the copy to exactly **`.env`**
   (no `.example` at the end).
   - Easiest way: right-click `.env.example` -> **Copy**, then
     right-click the folder -> **Paste**, then rename the new file to
     `.env`.
   - Or use the terminal:

     **Windows:**
     ```powershell
     copy .env.example .env
     ```

     **macOS/Linux:**
     ```bash
     cp .env.example .env
     ```
3. Open the new `.env` file in VS Code and replace the placeholder with
   your real API key from Step 7:

   ```
   NEWS_API_KEY=your_newsapi_key_here
   NEWS_API_COUNTRY=us
   ```

   becomes, for example:

   ```
   NEWS_API_KEY=b6b6c9f1a2d34e56a7b8c9d0e1f2a3b4
   NEWS_API_COUNTRY=us
   ```

4. Save the file (`Ctrl+S` / `Cmd+S`).

> 🔒 **Never share your `.env` file or commit it to GitHub.** It is
> already listed in `.gitignore` so Git will ignore it automatically.

---

## Step 9 - Run the Application

With your virtual environment still **activated** (`(venv)` visible in
the prompt) and your `.env` file set up, start the Flask server:

```bash
python app.py
```

(on macOS/Linux, use `python3 app.py` if `python` isn't recognized)

You should see terminal output similar to:

```
 * Serving Flask app 'app.py'
 * Debug mode: on
WARNING: This is a development server. Do not use it in a production deployment.
 * Running on http://127.0.0.1:5000
Press CTRL+C to quit
 * Restarting with stat
 * Debugger is active!
 * Debugger PIN: 123-456-789
```

This means the server is running successfully.

---

## Step 10 - Using the App

1. Open your web browser (Chrome, Firefox, Edge, etc.).
2. Go to: **http://127.0.0.1:5000**
3. You should see the News Reader interface load with a grid of news
   cards.
4. Try the features:
   - Click a **category pill** (Business, Sports, Technology, etc.) to
     filter news.
   - Type into the **search bar** to search for any keyword - results
     update automatically after you stop typing.
   - **Scroll down** - more articles load automatically at the bottom
     (infinite scroll).
   - Click the **🌙 / ☀️ icon** in the top-right corner to toggle
     **Dark Mode**.
   - Click **"Read Article ↗"** on any card to open the full article on
     its original website in a new tab.

---

## 11. Common Errors and Solutions

| Error / Symptom | Cause | Solution |
|---|---|---|
| `'python' is not recognized as an internal or external command` | Python isn't installed or wasn't added to PATH | Reinstall Python and check **"Add python.exe to PATH"**, then restart VS Code |
| `venv\Scripts\Activate.ps1 cannot be loaded because running scripts is disabled` | Windows PowerShell execution policy blocks scripts | Run `Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned`, then try activating again |
| `ModuleNotFoundError: No module named 'flask'` | Dependencies weren't installed, or the virtual environment isn't activated | Activate the venv (Step 5), then run `pip install -r requirements.txt` again |
| Browser shows `Server is missing a NEWS_API_KEY` | You didn't create `.env`, or it's still empty/placeholder text | Recheck Step 8 - make sure the file is named exactly `.env` and contains your real key |
| Browser shows `⚠️ apiKeyInvalid` or `401 Unauthorized` in the status banner | Wrong or expired NewsAPI key | Double-check you copied the full key correctly from https://newsapi.org/account |
| Browser shows `⚠️ You have made too many requests` / `429` | The free NewsAPI plan has a limited number of requests per day | Wait for the quota to reset (usually 24 hours) or reduce how often you refresh/search |
| Page loads but no articles appear and no error shows | Category returned zero results, or a network issue occurred | Try a different category or search term; check your internet connection |
| `Address already in use` / `port 5000 is already in use` | Another program (or a previous run of this app) is already using port 5000 | Stop the other process, or run on a different port: edit the last line of `app.py` to `app.run(debug=True, port=5001)` and open `http://127.0.0.1:5001` instead |
| Terminal shows `(venv)` disappeared after closing VS Code | Virtual environments must be reactivated per terminal session | Re-run the activation command from Step 5 every time you open a new terminal |
| Images not loading on some cards | Some articles simply don't provide an image | This is expected - a placeholder image is shown automatically |
| macOS: `command not found: python` | macOS often only ships `python3` | Use `python3` and `pip3` instead of `python` and `pip` throughout these instructions |

---

## 12. Stopping the Server

To stop the Flask development server, click inside the VS Code terminal
where it's running and press:

```
CTRL + C
```

You'll see the terminal prompt return to normal (no more "Running on
http://127.0.0.1:5000" message).

---

## 13. Rebuilding / Running Again Later

Every time you come back to work on this project after closing VS Code:

1. Open the project folder in VS Code.
2. Open a terminal (**Terminal -> New Terminal**).
3. **Activate** the virtual environment again (Step 5):
   - Windows: `venv\Scripts\Activate.ps1`
   - macOS/Linux: `source venv/bin/activate`
4. Run the app again:
   ```bash
   python app.py
   ```
5. Open **http://127.0.0.1:5000** in your browser.

You do **not** need to reinstall dependencies (Step 6) or recreate the
virtual environment (Step 4) again - those only happen once, unless you
delete the `venv` folder.

---

## 14. Tech Stack Summary

| Layer | Technology |
|---|---|
| Backend framework | Flask (Python) |
| News data source | [NewsAPI.org](https://newsapi.org) REST API |
| Frontend markup | HTML5 (Jinja2 templating) |
| Styling | Hand-written CSS3 with CSS variables (supports dark mode & responsive layout) |
| Frontend interactivity | Vanilla JavaScript (fetch API, IntersectionObserver for infinite scroll) |
| Configuration | `python-dotenv` reading a local `.env` file |

---

### 🎉 That's it!

You now have a fully working, modern news reader running locally on your
machine, with category filters, search, infinite scroll, dark mode, and
a clean responsive design. Enjoy reading the news!
