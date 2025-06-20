@echo off
setlocal

:: ============================================================================
::  Build Script for Visual Studio 2022
::  - This script runs Premake5 to generate project files.
::  - It should be run from the project's root directory.
:: ============================================================================

echo Running Premake5 to generate Visual Studio 2022 solution...
echo.

:: Use %~dp0 to get the directory of this batch file, making it runnable from anywhere.
set "PROJECT_ROOT=%~dp0"
set "BUILD_DIR=%PROJECT_ROOT%build"

:: Check if the build directory and premake5.exe exist.
if not exist "%BUILD_DIR%\premake5.exe" (
    echo ERROR: premake5.exe not found in '%BUILD_DIR%'
    echo Please ensure premake5.exe is placed in the 'build' directory.
    goto :error
)

:: Navigate to the build directory to run premake. pushd allows us to easily return.
pushd "%BUILD_DIR%"

:: Run Premake5. The '||' operator is a fallback for simple scripts.
:: A more explicit error check is better.
premake5.exe vs2022

:: Check the exit code of the last command. 0 means success.
if %errorlevel% neq 0 (
    echo.
    echo ERROR: Premake failed to generate project files.
    popd
    goto :error
)

:: Return to the original directory.
popd

echo.
echo ============================================================================
echo  Success!
echo  Visual Studio 2022 solution has been generated.
echo  You can now open the .sln file located in the 'build' directory.
echo ============================================================================
echo.
pause
exit /b 0

:error
echo.
echo Build script failed.
pause
exit /b 1