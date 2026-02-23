@echo off
chcp 65001 >nul 2>&1
echo ========================================
echo x86 (32-bit) Build - InventoryPro
echo ========================================
echo.

REM Use 32-bit Python - try py launcher first
set PYEXE=
py -3.11-32 -c "pass" 2>nul
if %errorlevel% equ 0 set PYEXE=py -3.11-32
if "%PYEXE%"=="" (
    py -3.12-32 -c "pass" 2>nul
    if %errorlevel% equ 0 set PYEXE=py -3.12-32
)
if "%PYEXE%"=="" (
    py -3.10-32 -c "pass" 2>nul
    if %errorlevel% equ 0 set PYEXE=py -3.10-32
)
if "%PYEXE%"=="" set PYEXE=python

echo Using: %PYEXE%
%PYEXE% --version
echo.

REM Install deps for 32-bit Python
echo Checking dependencies...
%PYEXE% -m pip install pyinstaller Pillow pandas openpyxl -q 2>nul
echo.

REM Clean and build
if exist dist rmdir /s /q dist
if exist build rmdir /s /q build
if exist InventoryPro_x86.spec del InventoryPro_x86.spec

echo Building x86 exe...
%PYEXE% -m PyInstaller --onefile --windowed --name "InventoryPro_x86" --hidden-import PIL --hidden-import PIL.Image --hidden-import PIL.ImageTk --hidden-import sqlite3 inventory_pro.py

if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo [OK] Build success!
    echo Output: dist\InventoryPro_x86.exe
    echo Default: admin / 123456
    echo ========================================
) else (
    echo.
    echo [FAIL] Build failed. If on ARM64 Windows, 32-bit Python may not work - try building on x86/x64 PC.
    echo.
)

pause
