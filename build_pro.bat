@echo off
chcp 936 >nul
echo ========================================
echo 进销存管理系统专业版 - 打包工具
echo ========================================
echo.

REM 检查Python
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [错误] 没有找到Python！
    echo 请先安装Python: https://www.python.org/downloads/
    echo 安装时记得勾选 "Add Python to PATH"
    pause
    exit /b 1
)

echo [OK] Python已安装
python --version
echo.

REM 检查并安装PyInstaller
echo 检查PyInstaller...
python -m pyinstaller --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [提示] PyInstaller未安装，正在安装...
    pip install --user pyinstaller
    echo [提示] 请重新运行此脚本
    pause
    exit /b 1
)

echo [OK] PyInstaller已就绪
echo.

REM 检查并安装Pillow
echo 检查Pillow...
python -c "import PIL" >nul 2>&1
if %errorlevel% neq 0 (
    echo [提示] Pillow未安装，正在安装...
    pip install --user Pillow
)

echo [OK] 依赖检查完成
echo.

REM 清理旧文件
echo 清理旧的打包文件...
if exist dist rmdir /s /q dist
if exist build rmdir /s /q build
if exist inventory_pro.spec del inventory_pro.spec

echo.
echo 开始打包专业版...
echo.

REM 使用PyInstaller打包
python -m pyinstaller --onefile ^
    --windowed ^
    --name "InventoryPro" ^
    --icon "" ^
    --add-data "inventory_pro.py;." ^
    --hidden-import PIL ^
    --hidden-import PIL.Image ^
    --hidden-import PIL.ImageTk ^
    --hidden-import sqlite3 ^
    --distpath "dist" ^
    --workpath "build" ^
    --specpath "." ^
    inventory_pro.py

if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo [OK] 打包成功！
    echo ========================================
    echo.
    echo 生成的文件：dist\InventoryPro.exe
    echo.

    REM 检查文件大小
    for %%%%I in (dist\InventoryPro.exe) do (
        set size=%%%%~zI
        set /a sizeMB=!size!/1048576
        echo 文件大小：!sizeMB! MB
    )

    echo.
    echo 功能特点：
    echo - 登录认证系统
    echo - 完整的进销存管理
    echo - 专业的界面设计
    echo - SQLite数据库存储
    echo - 多条件查询筛选
    echo - 报表统计分析
    echo.
    echo 使用说明：
    echo 1. 将 InventoryPro.exe 复制到任意文件夹
    echo 2. 双击运行
    echo 3. 默认账号：admin  密码：123456
    echo.

    REM 询问是否测试
    set /p test="是否立即测试运行？[Y/N]: "
    if /i "!test!==Y" (
        echo.
        echo 正在启动程序测试...
        start dist\InventoryPro.exe
    )
) else (
    echo.
    echo ========================================
    echo [FAIL] 打包失败！
    echo ========================================
    echo.
    echo 可能的原因：
    echo 1. 缺少依赖库
    echo 2. 代码错误
    echo 3. 权限不足
    echo.
    echo 请检查错误信息并重试
)

echo.
pause
