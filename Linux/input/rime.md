在 Linux 下使用 **中州韵（RIME）** 安装双拼输入法，可以通过以下步骤实现：

---

### **1. 安装 RIME 输入法框架**
根据你的发行版和输入法管理器选择以下一种方式：

#### **A. 使用 IBus（如 Ubuntu/Debian）**
```bash
sudo apt install ibus-rime
ibus restart  # 重启 IBus
```

#### **B. 使用 Fcitx5（推荐，如 Arch/Manjaro）**
```bash
sudo pacman -S fcitx5-rime  # Arch
sudo apt install fcitx5-rime  # Debian/Ubuntu
```

安装后，在系统设置中启用 Fcitx5 或 IBus，并添加 RIME 输入法。

--

### **2. 配置双拼输入方案**
RIME 支持多种双拼方案（如自然码、小鹤双拼、微软双拼等）。以下是配置方法：

#### **步骤 1：创建或修改 RIME 配置文件**
进入 RIME 配置目录：
```bash
mkdir -p ~/.config/ibus/rime  # IBus
mkdir -p ~/.local/share/fcitx5/rime  # Fcitx5
```

#### **步骤 2：选择双拼方案**
常用双拼方案列表：
- **自然码双拼**（推荐，键位布局简单）
- **小鹤双拼**
- **微软双拼**

编辑配置文件 `~/.config/ibus/rime/default.custom.yaml`（IBus）或 `~/.local/share/fcitx5/rime/default.custom.yaml`（Fcitx5），添加以下内容：

```yaml
patch:
  schema_list:
    - schema: double_pinyin  # 自然码双拼
    - schema: double_pinyin_flypy  # 小鹤双拼
    - schema: double_pinyin_mspy  # 微软双拼
```

#### **步骤 3：部署配置**
在 RIME 托盘图标上右键，选择 **“重新部署”**，或终端执行：
```bash
rime_deployer
```

---

### **3. 切换双拼输入法**
- 使用 `Ctrl + ~` 或 `F4` 打开方案选单，选择你配置的双拼方案。
- 输入时使用双拼键位（如自然码双拼的键位表如下）：

| 韵母 | 键位 | 例子 |
|------|------|------|
| ang  | h    | 当 `d h` |
| ing  | y    | 行 `x y` |
| ong  | s    | 中 `v s` |

---

### **4. 自定义双拼方案（可选）**
若需自定义双拼键位，创建 `double_pinyin.custom.yaml`：
```yaml
patch:
  speller/algebra:
    - derive/^([])a$/$1a/  # 自定义键位规则
```

---

### **常见问题**
- **双拼方案不生效**：检查配置文件名和语法（YAML 缩进敏感）。
- **部署失败**：查看日志 `~/.config/ibus/rime/ibus_rime.log`。
- **更多方案**：从 [RIME 官方方案](https://github.com/rime/rime-double-pinyin) 下载。

完成后，即可在 Linux 下流畅使用双拼输入法！

### **安装东风破**
```shell
git clone --depth 1 https://github.com/rime/plum.git
cd plum
bash rime-install :preset

# 安装双拼
bash rime-install double-pinyin
```