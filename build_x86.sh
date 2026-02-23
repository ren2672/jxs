#!/bin/bash
# macOS 打包脚本 - 支持 x86_64 (Intel) 架构
# 在 Apple Silicon Mac 上可以通过 Rosetta 2 运行 x86_64 程序

echo "========================================"
echo "进销存管理系统 - macOS 打包工具"
echo "目标架构: x86_64 (Intel)"
echo "========================================"
echo ""

# 检查 Python
if ! command -v python3 &> /dev/null; then
    echo "[错误] 没有找到 Python3！"
    echo "请先安装 Python: https://www.python.org/downloads/"
    exit 1
fi

echo "[OK] Python 已安装"
python3 --version
echo ""

# 检查并安装依赖
echo "检查所需依赖..."
python3 -c "import sqlite3, tkinter" 2>/dev/null
if [ $? -ne 0 ]; then
    echo "[错误] 缺少必要的库 (sqlite3 或 tkinter)！"
    exit 1
fi

python3 -c "import PIL" 2>/dev/null
if [ $? -ne 0 ]; then
    echo "[提示] 安装 Pillow..."
    pip3 install Pillow -q
fi

# 检查 PyInstaller
if ! command -v pyinstaller &> /dev/null; then
    echo "[提示] 安装 PyInstaller..."
    pip3 install pyinstaller -q
fi

echo "[OK] 所有依赖已就绪"
echo ""

# 清理旧文件
echo "清理旧的打包文件..."
rm -rf dist build *.spec 2>/dev/null

echo ""
echo "开始打包 (universal2 架构 - 支持 Intel + Apple Silicon)..."
echo ""

python3 -m PyInstaller \
    --onefile \
    --windowed \
    --target-arch universal2 \
    --name "InventoryPro_Universal" \
    --hidden-import PIL \
    --hidden-import PIL.Image \
    --hidden-import PIL.ImageTk \
    --hidden-import sqlite3 \
    inventory_pro.py

if [ $? -eq 0 ]; then
    echo ""
    echo "========================================"
    echo "[OK] 打包成功！"
    echo "========================================"
    echo ""
    echo "生成的文件："
    ls -lh dist/
    echo ""
    
    # 检查文件大小
    if [ -f "dist/InventoryPro_x86" ]; then
        SIZE=$(du -h dist/InventoryPro_x86 | cut -f1)
        echo "可执行文件大小: $SIZE"
    fi
    
    echo ""
    echo "使用说明："
    echo "1. 可执行文件位于: dist/InventoryPro_x86"
    echo "2. 此文件可在 Intel Mac (x86_64) 上运行"
    echo "3. 在 Apple Silicon Mac 上可通过 Rosetta 2 运行"
    echo ""
    echo "安装 Rosetta 2 (如需要):"
    echo "   softwareupdate --install-rosetta"
    echo ""
    
    # 询问是否测试运行
    read -p "是否立即测试运行? [y/N]: " TEST_RUN
    if [[ $TEST_RUN =~ ^[Yy]$ ]]; then
        echo ""
        echo "正在启动程序..."
        ./dist/InventoryPro_x86 &
    fi
else
    echo ""
    echo "========================================"
    echo "[FAIL] 打包失败！"
    echo "========================================"
    echo ""
    echo "可能的原因："
    echo "1. 代码存在语法错误"
    echo "2. 缺少依赖库"
    echo "3. 权限不足"
    echo ""
    echo "请检查错误信息并重试"
fi

echo ""
read -p "按回车键退出..."
