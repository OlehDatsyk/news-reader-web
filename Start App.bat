@echo off
setlocal EnableExtensions EnableDelayedExpansion
title News Reader - V2 (Web) - Startup
cd /d "%~dp0"

echo ============================================================
echo   News Reader - V2 (Web) - Startup Script
echo ============================================================
echo.

REM ------------------------------------------------------------------
REM 1. Check that Python is installed and available on PATH
REM ------------------------------------------------------------------
echo [1/6] Checking for Python...
where python >nul 2>&1
if errorlevel 1 (
    echo.
    echo   [ERROR] Python was not found on this computer, or it is not
    echo   added to your PATH.
    echo.
    echo   Please install Python from https://www.python.org/downloads/
    echo   and make sure to check "Add python.exe to PATH" during setup.
    echo   See INSTRUCTION.md, Section 2, for full instructions.
    echo.
    goto :error_exit
)
for /f "tokens=2" %%v in ('python --version 2^>^&1') do set PYVER=%%v
echo   Found Python %PYVER%
echo.

REM ------------------------------------------------------------------
REM 2. Create the virtual environment if it doesn't already exist
REM ------------------------------------------------------------------
echo [2/6] Checking for virtual environment...
if not exist "venv\Scripts\activate.bat" (
    echo   No virtual environment found. Creating one now ^(this only
    echo   happens once^)...
    python -m venv venv
    if errorlevel 1 (
        echo.
        echo   [ERROR] Failed to create the virtual environment.
        goto :error_exit
    )
    echo   Virtual environment created.
) else (
    echo   Virtual environment already exists.
)
echo.

REM ------------------------------------------------------------------
REM 3. Activate the virtual environment
REM ------------------------------------------------------------------
echo [3/6] Activating virtual environment...
call "venv\Scripts\activate.bat"
if errorlevel 1 (
    echo.
    echo   [ERROR] Failed to activate the virtual environment.
    goto :error_exit
)
echo   Virtual environment activated.
echo.

REM ------------------------------------------------------------------
REM 4. Install / update dependencies
REM ------------------------------------------------------------------
echo [4/6] Checking dependencies from requirements.txt...
if not exist "requirements.txt" (
    echo.
    echo   [ERROR] requirements.txt not found. Cannot install dependencies.
    goto :error_exit
)
python -m pip install --disable-pip-version-check -q -r requirements.txt
if errorlevel 1 (
    echo.
    echo   [ERROR] Failed to install one or more dependencies.
    echo   Check your internet connection and try again.
    goto :error_exit
)
echo   Dependencies are installed and up to date.
echo.

REM ------------------------------------------------------------------
REM 5. Verify the .env file exists
REM ------------------------------------------------------------------
echo [5/6] Checking for .env configuration file...
if not exist ".env" (
    echo.
    echo   [WARNING] No .env file was found.
    echo   The app needs a NEWS_API_KEY to fetch news articles.
    echo.
    if exist ".env.example" (
        echo   Creating .env from .env.example now. Please open the new
        echo   .env file and add your own NewsAPI key ^(see INSTRUCTION.md,
        echo   Section 11^) before using the app.
        copy /Y ".env.example" ".env" >nul
    ) else (
        echo   .env.example was also not found. Please create a .env file
        echo   manually with a line like: NEWS_API_KEY=your_key_here
    )
    echo.
) else (
    echo   .env file found.
)
echo.

REM ------------------------------------------------------------------
REM 6. Launch the application
REM ------------------------------------------------------------------
echo [6/6] Starting News Reader...
echo.
echo   The app will run at:  http://127.0.0.1:5000
echo   Keep this window open while using the app.
echo   Press CTRL+C in this window to stop the server.
echo.
echo ============================================================
echo.

python app.py

REM If the app exits (normally via CTRL+C, or due to a crash), pause so
REM the user can read any final messages before the window closes.
echo.
echo ============================================================
echo   The application has stopped.
echo ============================================================
pause
exit /b 0

:error_exit
echo.
echo ============================================================
echo   Startup could not complete. See the message above.
echo   Full setup instructions are available in INSTRUCTION.md.
echo ============================================================
pause
exit /b 1
