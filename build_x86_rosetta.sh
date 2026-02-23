#!/bin/bash
# macOS 打包脚本 - 使用 Rosetta 2 创建 x86_64 可执行文件
# 需要安装 Rosetta 2: softwareupdate --install-rosetta

echo "========================================"
echo "进销存管理系统 - x86_64 打包工具"
echo "========================================"
echo ""

# 检查是否在 Apple Silicon Mac 上
ARCH=$(uname -m)
if [ "$ARCH" != "arm64" ]; then
    echo "[提示] 当前已是 $ARCH 架构，直接打包即可"
    echo "运行: python3 -m PyInstaller --onefile --windowed inventory_pro.py"
    exit 0
fi

echo "当前架构: Apple Silicon (arm64)"
echo "目标架构: Intel (x86_64)"
echo ""

# 检查 Rosetta 2
if ! arch -x86_64 /usr/bin/uname -m >/dev/null 2>&1; then
    echo "[错误] Rosetta 2 未安装！"
    echo "请运行: softwareupdate --install-rosetta"
    exit 1
fi

echo "[OK] Rosetta 2 已安装"
echo ""

# 方案1: 尝试使用 Rosetta 运行 Python
# 需要先安装 x86_64 版本的 Python
echo "方案: 使用 Rosetta 2 + Homebrew 安装 x86_64 Python"
echo ""
echo "步骤:"
echo "1. 在 Rosetta shell 中安装 Homebrew:"
echo "   arch -x86_64 /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
echo ""
echo "2. 使用 x86_64 Homebrew 安装 Python:"
echo "   arch -x86_64 /usr/local/bin/brew install python@3.13"
echo ""
echo "3. 使用 x86_64 Python 打包:"
echo "   arch -x86_64 /usr/local/bin/python3 -m PyInstaller --onefile --windowed inventory_pro.py"
echo ""
echo "----------------------------------------"
echo "或者，直接在 Intel Mac 上打包更简单！"
echo "----------------------------------------"
echo ""

# 检查是否有 x86_64 Python
X86_PYTHON=""
for path in "/usr/local/bin/python3" "/usr/local/bin/python3.13" "/usr/local/bin/python3.12" "/opt/homebrew_x86/bin/python3"; do
    if [ -f "$path" ]; then
        if arch -x86_64 "$path" -c "import sys; print(sys.maxsize > 2**32)" >/dev/null 2>&1; then
            X86_PYTHON="$path"
            break
        fi
    fi
done

if [ -n "$X86_PYTHON" ]; then
    echo "[OK] 找到 x86_64 Python: $X86_PYTHON"
    echo ""
    read -p "是否立即使用 x86_64 Python 打包? [Y/n]: " CONFIRM
    if [[ ! $CONFIRM =~ ^[Nn]$ ]]; then
        echo ""
        echo "开始打包..."
        
        # 使用 x86_64 Python 运行 PyInstaller
        arch -x86_64 "$X86_PYTHON" -m pip install pyinstaller pillow -q 2>/dev/null
        
        rm -rf dist_x86 build_x86 *.spec 2>/dev/null
        
        arch -x86_64 "$X86_PYTHON" -m PyInstaller \
            --onefile \
            --windowed \
            --name "InventoryPro_x86" \
            --distpath "dist_x86" \
            --workpath "build_x86" \
            --hidden-import PIL \
            --hidden-import PIL.Image \
            --hidden-import PIL.ImageTk \
            --hidden-import sqlite3 \
            inventory_pro.py
        
        if [ $? -eq 0 ]; then
            echo ""
            echo "========================================"
            echo "[OK] x86_64 打包成功！"
            echo "========================================"
            echo ""
            echo "生成的文件:"
            ls -lh dist_x86/
            echo ""
            echo "架构信息:"
            file dist_x86/InventoryPro_x86
        else
            echo ""
            echo "[FAIL] 打包失败！"
        fi
    fi
else
    echo "[提示] 未找到 x86_64 Python"
    echo ""
    echo "建议: 直接在 Intel Mac 上运行打包脚本更简单可靠。"
    echo ""
    echo "或者按上述步骤安装 x86_64 Python 后再运行此脚本。"
fi

echo ""
read -p "按回车键退出..."
