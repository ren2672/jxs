@echo off
chcp 65001 >nul 2>&1
echo ========================================
echo 快速打包 - 进销存管理系统
echo ========================================
echo.

REM 清理旧文件
if exist dist rmdir /s /q dist
if exist build rmdir /s /q build

echo 正在打包...
echo.

REM 使用PyInstaller打包（简化版）
python -m PyInstaller --onefile --windowed --name "InventoryPro" --hidden-import PIL --hidden-import PIL.Image --hidden-import PIL.ImageTk --hidden-import sqlite3 inventory_pro.py

if %errorlevel% equ 0 (
    echo.
    echo [OK] 打包成功！
    echo 生成文件：dist\InventoryPro.exe
    echo.
) else (
    echo.
    echo [FAIL] 打包失败！请检查错误信息。
    echo.
)

pause
