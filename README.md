# 进销存管理系统专业版

一个功能完整的进销存管理系统，支持入库、出库、库存查询、商品管理、统计报表等功能。

## 🚀 快速打包

### 方式一：使用打包脚本（推荐）
```bash
# 直接运行打包脚本
build_pro.bat
```

### 方式二：使用PyInstaller命令
```bash
python -m PyInstaller --onefile --windowed --name "InventoryPro" --hidden-import PIL --hidden-import PIL.Image --hidden-import PIL.ImageTk --hidden-import sqlite3 inventory_pro.py
```

打包完成后，`dist/InventoryPro.exe` 就是可执行文件！

## ✨ 主要功能

### 核心功能
- 🔐 **登录认证系统**：MD5密码加密，多用户支持，权限管理
- 📊 **仪表盘**：实时统计卡片，最近交易记录
- 📥 **入库管理**：支持批次号、多商品批量入库，单据查询和删除
- 📤 **出库管理**：库存检查、防止负库存，单据查询和删除
- 📦 **库存查询**：多条件筛选、颜色预警，数据导出，初始化数据
- 📝 **商品管理**：新增商品、导入/导出CSV、删除商品
- 📈 **统计报表**：销售报表、采购报表、库存报表、利润报表，支持日期范围，导出Excel
- ⚙️ **系统设置**：基本设置（系统名称、公司信息、初始化密码）、用户管理（添加/删除/编辑）、权限设置、数据备份/恢复

### 技术特性
- 💻 **独立运行**：无需安装Python，双击EXE即用
- 💾 **SQLite数据库**：数据安全可靠
- 🎨 **专业界面**：美观的GUI设计
- 🔍 **多条件查询**：支持日期、单号、客户、商品等多维度筛选
- ✅ **数据验证**：完整的输入验证和错误提示

## 📁 文件说明

### 主程序文件
- `inventory_pro.py` - 专业版主程序（最新完整版本）

### 打包脚本
- `build_pro.bat` - 完整版打包脚本（包含依赖检查和详细提示）
- `快速打包.bat` - 快速打包脚本（简化版）
- `build_x86_windows.bat` - **x86 (32位) Windows 打包脚本**（生成兼容 32 位系统的 exe）

### 配置文件
- `requirements.txt` - Python依赖
- `InventoryPro.spec` - PyInstaller配置文件

### 文档
- `README.md` - 本文件（项目说明）
- `进销存系统使用说明.md` - 用户使用手册（详细功能说明）

## 🔧 最新修复（2025年1月）

### 已修复的问题
1. ✅ **出入库明细录入功能完全修复**
   - 修复了入库单明细添加时total_label引用问题
   - 修复了出库单明细添加时total_label引用问题
   - 修复了删除商品后未更新总金额的问题
   - 优化了update_total_amount方法，支持入库和出库不同的列索引

2. ✅ **库存查询和更新逻辑优化**
   - 修复了出库单库存查询的SQL GROUP BY问题
   - 优化了入库单库存更新逻辑
   - 增加了出库单保存时的库存充足性检查
   - 防止负库存产生

3. ✅ **用户体验优化**
   - 改进了输入窗口大小和布局
   - 增加了商品重复添加检查
   - 改进了错误提示信息
   - 添加了取消按钮，窗口自动居中

## 📦 打包 x86 (32 位) 版本

如需生成 **x86 可执行文件**（在 32 位 Windows 或老旧电脑上运行）：

1. **安装 32 位 Python**：从 [python.org](https://www.python.org/downloads/windows/) 下载并安装 "Windows installer (32-bit)"
2. 运行打包脚本：
   ```bash
   build_x86_windows.bat
   ```
3. 脚本会自动检测 32 位 Python（如 `py -3.12-32`），并生成 `dist/InventoryPro_x86.exe`

> 说明：PyInstaller 生成的 exe 架构取决于运行 PyInstaller 的 Python 架构。用 64 位 Python 只能生成 64 位 exe，要得到 x86 exe 必须使用 32 位 Python。

> 注意：若在 ARM64 架构的 Windows 上，32 位 Python 通过模拟运行，可能无法成功打包。建议在 x86/x64 电脑上执行 x86 打包。

## 📦 打包要点

打包命令已包含所有必要参数：
- `--onefile` - 打包为单文件
- `--windowed` - 无控制台窗口（GUI模式）
- `--hidden-import PIL` - 处理PIL/Pillow依赖
- `--hidden-import sqlite3` - 处理SQLite依赖

## 🎉 使用体验

1. 运行 `InventoryPro.exe`
2. 登录（默认账号：admin，密码：123456）
3. 开始使用各种功能

### 默认账号
- 用户名：`admin`
- 密码：`123456`

## ⚠️ 注意事项

1. 首次运行会在程序目录下的 `data` 子目录创建 `inventory.db` 数据库文件
2. 数据备份文件保存在 `data/bak` 子目录
3. 建议定期备份数据库文件
4. 退出程序时会提示是否备份数据
5. 如需迁移，请复制整个程序目录（包含 `data` 目录）
6. 初始化数据功能会清空所有数据，需输入密码（默认123，可在系统设置中修改）

## 📂 目录结构

运行后会自动创建以下目录结构：
```
InventoryPro.exe
data/
  ├── inventory.db      # 数据库文件
  └── bak/              # 备份文件目录
      └── inventory.db_2025-01-XX_XX-XX-XX.bak
```