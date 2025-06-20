@echo off
setlocal

:: ============================================================================
::  Clean and Build Script for MinGW (GMake2)
::
::  - This script first CLEANS the project using 'make clean'.
::  - It then BUILDS the project using 'make'.
::  - If Makefiles are not found, it runs Premake5 first to generate them.
:: ============================================================================

:: Use %~dp0 to get the directory of this batch file, making it runnable from anywhere.
set "PROJECT_ROOT=%~dp0"
set "BUILD_DIR=%PROJECT_ROOT%build"
set "MAKEFILE=%PROJECT_ROOT%Makefile"

:: --- Step 1: Check if Premake5 exists ---
if not exist "%BUILD_DIR%\premake5.exe" (
    echo ERROR: premake5.exe not found in '%BUILD_DIR%'
    echo Please ensure premake5.exe is placed in the 'build' directory.
    goto :error
)

:: --- Step 2: Check for Makefiles and generate if missing ---
if not exist "%MAKEFILE%" (
    echo Makefile not found. Running Premake5 to generate project files...
    echo.
    pushd "%BUILD_DIR%"
    premake5.exe gmake2

    if %errorlevel% neq 0 (
        echo.
        echo ERROR: Premake failed to generate project files.
        popd
        goto :error
    )
    popd
    echo Project files generated successfully.
    echo.
)

:: --- Step 3: Clean previous build ---
echo ============================================================================
echo  CLEANING previous build...
echo ============================================================================
echo.

:: Use mingw32-make as established. The 'clean' might not fail if there's
:: nothing to clean, but we check for errors just in case.
mingw32-make SHELL=CMD clean

if %errorlevel% neq 0 (
    echo.
    echo WARNING: The 'clean' step failed or produced an error. Continuing anyway.
    echo.
)

:: --- Step 4: Build the project ---
echo ============================================================================
echo  BUILDING the project...
echo ============================================================================
echo.

mingw32-make SHELL=CMD

:: Check the exit code of the build command.
if %errorlevel% neq 0 (
    echo.
    echo ERROR: The build failed. Check the output above for errors.
    goto :error
)

echo.
echo ============================================================================
echo  Success!
echo  The project has been successfully cleaned and rebuilt.
echo ============================================================================
echo.
pause
exit /b 0

:error
echo.
echo ============================================================================
echo  Script failed.
echo ============================================================================
echo.
pause
exit /b 1