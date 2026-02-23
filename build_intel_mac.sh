#!/bin/bash
# macOS x86_64 一键打包脚本
# 在 Intel Mac 上运行此脚本

echo "========================================"
echo "进销存管理系统 - 一键打包工具"
echo "========================================"
echo ""

# 检查 Python
if ! command -v python3 &> /dev/null; then
    echo "[错误] 未找到 Python3"
    echo "请先安装 Python: https://www.python.org/downloads/"
    exit 1
fi

echo "Python 版本:"
python3 --version
echo ""

# 安装依赖
echo "[1/3] 安装打包工具..."
pip3 install pyinstaller pillow -q

# 清理旧文件
echo "[2/3] 清理旧文件..."
rm -rf dist build *.spec 2>/dev/null

# 打包
echo "[3/3] 开始打包..."
python3 -m PyInstaller \
    --onefile \
    --windowed \
    --name "InventoryPro" \
    --hidden-import PIL \
    --hidden-import PIL.Image \
    --hidden-import PIL.ImageTk \
    --hidden-import sqlite3 \
    inventory_pro.py

if [ $? -eq 0 ]; then
    echo ""
    echo "========================================"
    echo "✅ 打包成功！"
    echo "========================================"
    echo ""
    ls -lh dist/
    echo ""
    echo "生成的文件: dist/InventoryPro"
    echo ""
    echo "可以直接在 macOS 上运行此文件"
else
    echo ""
    echo "❌ 打包失败"
fi

read -p "按回车键退出..."
