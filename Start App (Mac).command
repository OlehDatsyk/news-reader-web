#!/bin/bash
# ============================================================
#  News Reader - V2 (Web) - macOS Startup Script
#  Double-click this file in Finder to set up and launch the app.
# ============================================================

# Move into the folder this script lives in, no matter where it's
# double-clicked from.
cd "$(dirname "$0")" || exit 1

echo "============================================================"
echo "  News Reader - V2 (Web) - Startup Script"
echo "============================================================"
echo

error_exit () {
    echo
    echo "============================================================"
    echo "  Startup could not complete. See the message above."
    echo "  Full setup instructions are available in INSTRUCTION.md."
    echo "============================================================"
    echo
    read -n 1 -s -r -p "Press any key to close this window..."
    echo
    exit 1
}

# ------------------------------------------------------------------
# 1. Check that Python 3 is installed
# ------------------------------------------------------------------
echo "[1/6] Checking for Python 3..."
if command -v python3 >/dev/null 2>&1; then
    PYTHON_BIN=python3
elif command -v python >/dev/null 2>&1; then
    PYTHON_BIN=python
else
    echo
    echo "  [ERROR] Python was not found on this computer."
    echo
    echo "  Please install Python from https://www.python.org/downloads/"
    echo "  then double-click this file again."
    echo "  See INSTRUCTION.md, Section 2, for full instructions."
    error_exit
fi
PYVER=$($PYTHON_BIN --version 2>&1)
echo "  Found $PYVER"
echo

# ------------------------------------------------------------------
# 2. Create the virtual environment if it doesn't already exist
# ------------------------------------------------------------------
echo "[2/6] Checking for virtual environment..."
if [ ! -f "venv/bin/activate" ]; then
    echo "  No virtual environment found. Creating one now (this only"
    echo "  happens once)..."
    "$PYTHON_BIN" -m venv venv
    if [ $? -ne 0 ]; then
        echo
        echo "  [ERROR] Failed to create the virtual environment."
        error_exit
    fi
    echo "  Virtual environment created."
else
    echo "  Virtual environment already exists."
fi
echo

# ------------------------------------------------------------------
# 3. Activate the virtual environment
# ------------------------------------------------------------------
echo "[3/6] Activating virtual environment..."
# shellcheck disable=SC1091
source "venv/bin/activate"
if [ $? -ne 0 ]; then
    echo
    echo "  [ERROR] Failed to activate the virtual environment."
    error_exit
fi
echo "  Virtual environment activated."
echo

# ------------------------------------------------------------------
# 4. Install / update dependencies
# ------------------------------------------------------------------
echo "[4/6] Checking dependencies from requirements.txt..."
if [ ! -f "requirements.txt" ]; then
    echo
    echo "  [ERROR] requirements.txt not found. Cannot install dependencies."
    error_exit
fi
pip install --disable-pip-version-check -q -r requirements.txt
if [ $? -ne 0 ]; then
    echo
    echo "  [ERROR] Failed to install one or more dependencies."
    echo "  Check your internet connection and try again."
    error_exit
fi
echo "  Dependencies are installed and up to date."
echo

# ------------------------------------------------------------------
# 5. Verify the .env file exists
# ------------------------------------------------------------------
echo "[5/6] Checking for .env configuration file..."
if [ ! -f ".env" ]; then
    echo
    echo "  [WARNING] No .env file was found."
    echo "  The app needs a NEWS_API_KEY to fetch news articles."
    echo
    if [ -f ".env.example" ]; then
        echo "  Creating .env from .env.example now. Please open the new"
        echo "  .env file and add your own NewsAPI key (see INSTRUCTION.md,"
        echo "  Section 11) before using the app."
        cp ".env.example" ".env"
    else
        echo "  .env.example was also not found. Please create a .env file"
        echo "  manually with a line like: NEWS_API_KEY=your_key_here"
    fi
    echo
else
    echo "  .env file found."
fi
echo

# ------------------------------------------------------------------
# 6. Launch the application
# ------------------------------------------------------------------
echo "[6/6] Starting News Reader..."
echo
echo "  The app will run at:  http://127.0.0.1:5000"
echo "  Keep this window open while using the app."
echo "  Press CTRL+C in this window to stop the server."
echo
echo "============================================================"
echo

"$PYTHON_BIN" app.py

echo
echo "============================================================"
echo "  The application has stopped."
echo "============================================================"
read -n 1 -s -r -p "Press any key to close this window..."
echo
exit 0
