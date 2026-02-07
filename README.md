# Ultra Neovim

macOS Terminal / Zero Plugins / Pure Lua / Neovim 0.11+

一个追求完美平衡的 Neovim 配置。单文件 `init.lua`，399 行，零插件依赖，不针对任何特定语言，只面向 macOS 终端环境。

---

## 环境要求

| 项目 | 要求 |
|------|------|
| Neovim | >= 0.11 (使用了 `vim.hl.on_yank`、`vim.diagnostic.jump` 等 0.11 API) |
| 系统 | macOS (剪贴板通过 `pbcopy`/`pbpaste` 集成，`gx` 调用 `open` 命令) |
| 终端 | 支持 true color 的终端 (Terminal.app / iTerm2 / Ghostty / Kitty / WezTerm) |

**可选依赖** (非必须，有则体验更好)：

| 工具 | 用途 |
|------|------|
| [ripgrep](https://github.com/BurntSushi/ripgrep) (`rg`) | 替代内置 grep，`<leader>/` 全局搜索更快 |
| [fd](https://github.com/sharkdp/fd) | 替代 find，`<leader>f` 文件查找更快 |

```bash
brew install ripgrep fd
```

---

## 安装

### Install

```bash
bash <(curl -s https://raw.githubusercontent.com/FZRKexEr/nvim/main/install.sh)
```

### 手动安装

```bash
# 备份已有配置
mv ~/.config/nvim/init.lua ~/.config/nvim/init.lua.bak

# 放入 init.lua 即可，无需安装任何插件
cp init.lua ~/.config/nvim/init.lua
```

打开 Neovim 即可使用，无需执行任何安装命令。

---

## 文件结构

```
~/.config/nvim/
└── init.lua          # 全部配置，单文件，399 行
```

没有 `lua/` 子目录，没有 `plugin/` 目录，没有 `lazy-lock.json`。一个文件，即是全部。

---

## 配置分区总览

`init.lua` 按照以下顺序组织，每个分区用 `-- ──` 分隔线标注：

```
Leader          7-8        Leader 键定义
Options        10-96       所有 vim.opt 设置
Keymaps        98-221      键位映射
Toggles       223-242      开关类快捷键 + Zen 模式
Netrw         244-247      内置文件浏览器配置
Diagnostics   249-264      诊断信息显示配置
Autocommands  266-332      自动命令
Statusline    334-381      纯 Lua 状态栏
Colors        383-399      高亮组 + 配色方案
```

---

## Options 详解

### UI 显示

| 选项 | 值 | 说明 |
|------|-----|------|
| `number` | `true` | 显示行号 |
| `relativenumber` | `true` | 相对行号，方便用 `5j` `12k` 等动作精确跳转 |
| `signcolumn` | `"yes"` | 始终显示标记列，避免文本左右跳动 |
| `cursorline` | `true` | 高亮当前行 |
| `termguicolors` | `true` | 启用 24 位真彩色 |
| `showmode` | `false` | 隐藏底部 `-- INSERT --` 提示，因为自定义状态栏已经显示模式 |
| `laststatus` | `3` | 全局状态栏 (所有窗口共享一条) |
| `pumheight` | `10` | 补全弹出菜单最多显示 10 项 |
| `pumblend` | `10` | 弹出菜单 10% 透明 |
| `winblend` | `10` | 浮动窗口 10% 透明 |
| `wrap` | `false` | 默认不折行 (可用 `<leader>tw` 切换) |
| `linebreak` | `true` | 开启 wrap 时在单词边界处断行，不会从单词中间截断 |
| `breakindent` | `true` | 折行后的续行保持缩进对齐 |
| `showbreak` | `"↪ "` | 折行续行前显示 `↪` 标记 |
| `list` | `true` | 显示不可见字符 |
| `listchars` | `tab:» ·trail:· nbsp:␣` | Tab 显示为 `»`，行尾空格显示为 `·`，不间断空格显示为 `␣` |
| `fillchars` | (box-drawing) | 使用 Unicode 制表符绘制窗口分隔线、折叠标记等，视觉更精致 |
| `shortmess` | 追加 `"Ic"` | `I` = 不显示启动介绍页，`c` = 不显示补全消息 |
| `title` | `true` | 在终端标题栏显示当前文件名 |

### 行为

| 选项 | 值 | 说明 |
|------|-----|------|
| `mouse` | `"a"` | 全模式鼠标支持 (点击定位、拖拽选择、滚轮滚动) |
| `clipboard` | `"unnamedplus"` | 与 macOS 系统剪贴板同步。复制 = `Cmd+C`，粘贴 = `Cmd+V`，无缝流转 |
| `updatetime` | `250` | CursorHold 事件触发间隔，从默认 4000ms 降至 250ms，提高响应速度 |
| `timeoutlen` | `400` | 组合键等待时间 400ms (默认 1000ms)，让 Leader 组合键更灵敏 |
| `confirm` | `true` | 关闭未保存文件时弹出确认对话框，而非直接报错 |
| `virtualedit` | `"block"` | 在 Visual Block 模式中光标可以移动到行尾之后的空白处 |
| `inccommand` | `"split"` | `:s` 替换时实时预览效果，并在分割窗口中显示所有匹配行 |

### 搜索

| 选项 | 值 | 说明 |
|------|-----|------|
| `ignorecase` | `true` | 搜索时忽略大小写 |
| `smartcase` | `true` | 搜索词中包含大写字母时自动切换为大小写敏感 |
| `hlsearch` | `true` | 高亮所有搜索匹配项 (按 `Esc` 清除高亮) |

**搜索行为示例**：`/hello` 匹配 hello、Hello、HELLO；`/Hello` 只匹配 Hello。

### 缩进

| 选项 | 值 | 说明 |
|------|-----|------|
| `expandtab` | `true` | 按 Tab 键插入空格 |
| `tabstop` | `4` | 一个 Tab 字符显示为 4 格宽 |
| `shiftwidth` | `4` | `>>` `<<` 缩进/取消缩进时移动 4 格 |
| `softtabstop` | `4` | 按 Tab/Backspace 时按 4 格为单位操作 |
| `smartindent` | `true` | 新行自动跟随上一行的缩进 |
| `shiftround` | `true` | 缩进时对齐到 `shiftwidth` 的整数倍 |

### 窗口分割

| 选项 | 值 | 说明 |
|------|-----|------|
| `splitright` | `true` | 垂直分割时新窗口出现在右边 |
| `splitbelow` | `true` | 水平分割时新窗口出现在下边 |
| `splitkeep` | `"screen"` | 分割窗口时保持屏幕内容不跳动 |

### 滚动

| 选项 | 值 | 说明 |
|------|-----|------|
| `scrolloff` | `8` | 光标距离屏幕上下边缘始终保持 8 行可见内容 |
| `sidescrolloff` | `8` | 光标距离屏幕左右边缘保持 8 列 |
| `smoothscroll` | `true` | 平滑滚动 (Neovim 0.10+ 特性) |

### 折叠

| 选项 | 值 | 说明 |
|------|-----|------|
| `foldmethod` | `"indent"` | 按缩进层级折叠，通用于所有文件类型 |
| `foldlevel` | `99` | 默认展开所有折叠 |
| `foldlevelstart` | `99` | 打开文件时展开所有折叠 |

折叠快捷键使用 Neovim 内置默认：`za` 切换折叠，`zR` 全部展开，`zM` 全部折叠。

### 持久化

| 选项 | 值 | 说明 |
|------|-----|------|
| `undofile` | `true` | 撤销历史持久化到磁盘。关闭文件再打开，仍可 `u` 撤销之前的编辑 |
| `undolevels` | `10000` | 最多保留 10000 步撤销历史 |
| `backup` | `false` | 不创建备份文件 |
| `swapfile` | `false` | 不创建交换文件 (依赖 undofile 保障安全) |

### 命令行补全

| 选项 | 值 | 说明 |
|------|-----|------|
| `wildmode` | `"longest:full,full"` | 第一次 Tab 补全最长公共前缀并显示菜单，第二次 Tab 逐项切换 |
| `wildignorecase` | `true` | 文件名补全忽略大小写 |

### Grep 集成

如果系统安装了 `rg` (ripgrep)，自动将 `:grep` 命令切换为使用 ripgrep，搜索速度可提升数十倍。

### macOS 终端

| 选项 | 值 | 说明 |
|------|-----|------|
| `guicursor` | (三段式) | Normal/Visual = 方块光标，Insert = 细竖线，Replace = 下划线 |
| `ttimeoutlen` | `10` | 终端转义序列超时 10ms，让模式切换几乎无延迟 |

---

## 快捷键完整参考

Leader 键为 **空格 (Space)**。

### 基础操作

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `Esc` | Normal | 清除搜索高亮 |
| `j` / `k` | Normal, Visual | 智能行移动 — 无计数前缀时按视觉行移动 (适合 wrap 开启时)，有前缀时按实际行移动 |
| `J` | Normal | 合并下一行到当前行，**光标位置不变** (原版 `J` 会让光标跳到合并点) |
| `p` | Visual | 粘贴替换选中文本，**不会覆盖寄存器**。支持连续多次粘贴同一内容 |

### 窗口

| 快捷键 | 说明 |
|--------|------|
| `Ctrl-h` | 跳到左边窗口 |
| `Ctrl-j` | 跳到下边窗口 |
| `Ctrl-k` | 跳到上边窗口 |
| `Ctrl-l` | 跳到右边窗口 |
| `Ctrl-Up` | 增加窗口高度 (+2) |
| `Ctrl-Down` | 减少窗口高度 (-2) |
| `Ctrl-Left` | 减少窗口宽度 (-2) |
| `Ctrl-Right` | 增加窗口宽度 (+2) |

### 缓冲区

| 快捷键 | 说明 |
|--------|------|
| `Shift-h` | 上一个缓冲区 |
| `Shift-l` | 下一个缓冲区 |
| `<leader>b` | 缓冲区切换器 (弹出列表选择) |
| `<leader>x` | 关闭当前缓冲区 |

### 编辑增强

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `J` / `K` | Visual | 将选中行整体向下/上移动，自动重新缩进并保持选中 |
| `<` / `>` | Visual | 缩进/取消缩进，操作后**保持 Visual 选中状态** (不会退出选择) |

### 居中导航

以下操作执行后，屏幕会自动居中到光标所在行，视线始终在屏幕中央：

| 快捷键 | 说明 |
|--------|------|
| `n` / `N` | 搜索下一个/上一个匹配 + 居中 |
| `Ctrl-d` | 向下翻半页 + 居中 |
| `Ctrl-u` | 向上翻半页 + 居中 |
| `G` | 跳到文件末尾 + 居中 |

### Leader 快捷键

| 快捷键 | 说明 |
|--------|------|
| `<leader>w` | 保存文件 (`:w`) |
| `<leader>q` | 退出 (`:q`) |
| `<leader>a` | 全选文件内容 |
| `<leader>e` | 切换文件浏览器侧边栏 (netrw)。再按一次关闭 |
| `<leader>f` | 文件查找器 — 弹出当前目录下所有文件列表，选择后打开。优先使用 `fd`，回退到 `find` |
| `<leader>b` | 缓冲区切换器 — 列出所有已打开的缓冲区 |
| `<leader>x` | 关闭当前缓冲区 |
| `<leader>/` | 全局文本搜索 (Grep) — 输入关键词后在 Quickfix 窗口显示结果。优先使用 `rg` |
| `<leader>d` | 在浮动窗口中显示当前行的诊断信息 |

### Quickfix 与诊断

| 快捷键 | 说明 |
|--------|------|
| `]q` | 下一个 Quickfix 条目 + 居中 |
| `[q` | 上一个 Quickfix 条目 + 居中 |
| `]d` | 下一个诊断 |
| `[d` | 上一个诊断 |

### 终端与 macOS

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `Esc Esc` | Terminal | 退出终端模式回到 Normal 模式 (按两次 Esc) |
| `gx` | Normal | 用 macOS `open` 命令打开光标下的 URL 或文件路径 |

### 开关切换 (`<leader>t`)

| 快捷键 | 说明 |
|--------|------|
| `<leader>tw` | 切换自动换行 (wrap) |
| `<leader>ts` | 切换拼写检查 (spell) |
| `<leader>tn` | 切换相对行号 / 绝对行号 |
| `<leader>tl` | 切换不可见字符显示 (listchars) |

### Zen 模式

| 快捷键 | 说明 |
|--------|------|
| `<leader>z` | 切换 Zen 模式 |

Zen 模式下会隐藏：行号、标记列、状态栏、光标行高亮、Tab 栏、不可见字符。只留下纯粹的文本内容，适合专注写作。再按一次恢复全部 UI。

---

## 自动命令

配置中注册了 7 个自动命令组，全部使用 `ultra_` 前缀避免冲突：

### Yank 高亮 (`ultra_yank`)

复制文本时，被复制的区域会短暂闪烁高亮 200ms，提供清晰的视觉反馈。

### 光标位置记忆 (`ultra_cursor`)

重新打开文件时，光标自动恢复到上次离开时的位置。

### 自动调整窗口 (`ultra_resize`)

终端窗口大小改变时，所有分割窗口自动等比例调整，不会出现某个窗口被挤压的情况。

### 快速关闭 (`ultra_close_q`)

在 help、man、quickfix、checkhealth、netrw 等辅助窗口中，按 `q` 即可直接关闭，无需输入 `:q`。

### 自动创建目录 (`ultra_mkdir`)

保存文件时，如果目标路径的父目录不存在，自动递归创建。例如直接 `:e a/b/c/new.txt` 然后 `:w`，会自动创建 `a/b/c/` 目录。

### 终端优化 (`ultra_term`)

在 Neovim 内置终端中：
- 自动进入 Insert 模式 (打开即可输入命令)
- 隐藏行号和标记列 (终端中不需要这些)

### 格式化选项 (`ultra_fmtopts`)

禁止在新行自动插入注释前缀。默认行为下，在注释行按回车会自动添加 `//` 或 `#` 前缀，此设置关闭该行为。

---

## 状态栏

纯 Lua 实现的全局状态栏，不依赖任何插件。

### 布局

```
┌─────────┬────────────────────────────────┬───────────────────────┐
│  MODE   │  filename.txt [+]             │  lua  utf-8[unix]  42:13  68%  │
└─────────┴────────────────────────────────┴───────────────────────┘
```

- **左侧**：模式指示器 (彩色背景) + 文件名 + 修改标记 `[+]` + 只读标记 `[RO]`
- **右侧**：文件类型 + 编码 + 换行格式 + 行:列 + 百分比位置

### 模式颜色

| 模式 | 颜色 | 色值 |
|------|------|------|
| NORMAL | 蓝色 | `#7aa2f7` |
| INSERT | 绿色 | `#9ece6a` |
| VISUAL / V-LINE / V-BLOCK / SELECT | 紫色 | `#bb9af7` |
| REPLACE / V-REPL | 红色 | `#f7768e` |
| COMMAND / EX / TERMINAL / SHELL | 橙色 | `#e0af68` |

颜色灵感来自 Tokyo Night 主题，在 `habamax` 配色方案下作为点缀色使用。切换配色方案时颜色会自动重新应用 (通过 `ColorScheme` 自动命令)。

---

## 内置文件浏览器 (Netrw)

Netrw 是 Neovim 内置的文件浏览器，本配置对其进行了优化：

| 设置 | 效果 |
|------|------|
| `netrw_banner = 0` | 隐藏顶部帮助信息 |
| `netrw_liststyle = 3` | 树形视图 |
| `netrw_winsize = 25` | 侧边栏占屏幕宽度的 25% |

使用 `<leader>e` 切换侧边栏，在侧边栏中：
- 回车打开文件/展开目录
- `-` 返回上一级目录
- `%` 新建文件
- `d` 新建目录
- `D` 删除
- `R` 重命名
- `q` 关闭侧边栏

---

## 诊断显示

| 严重级别 | 图标 | 说明 |
|---------|------|------|
| ERROR | `✘` | 错误 |
| WARN | `▲` | 警告 |
| HINT | `⚑` | 提示 |
| INFO | `●` | 信息 |

诊断信息以下划线 + 行内虚拟文本的方式显示，浮动窗口使用圆角边框，按严重级别排序。

---

## 配色方案

默认使用 Neovim 内置的 **habamax** — 一个干净的深灰色暗色主题。

如需更换，修改 `init.lua` 最后一行：

```lua
vim.cmd.colorscheme("habamax")    -- 当前
-- vim.cmd.colorscheme("retrobox")   -- 暖色复古
-- vim.cmd.colorscheme("sorbet")     -- 多彩
-- vim.cmd.colorscheme("zaibatsu")   -- 赛博朋克
-- vim.cmd.colorscheme("quiet")      -- 极简
-- vim.cmd.colorscheme("default")    -- Neovim 0.10+ 新默认，比旧版好看很多
```

---

## 设计决策

### 为什么零插件

- **即开即用** — 任何一台装了 Neovim 0.11 的 Mac 上，拷贝一个文件即可使用
- **零维护成本** — 不需要 `Lazy.nvim`，不需要 `mason.nvim`，不需要 `:PackerSync`
- **启动速度** — 没有插件加载开销，启动几乎瞬间完成
- **完全理解** — 399 行代码，每一行都清楚做了什么

### 为什么不针对特定语言

这是一个**文本编辑器**配置，不是 IDE 配置。如果需要特定语言支持 (LSP、格式化、调试)，建议在此基础上按需添加，而不是让基础配置变得臃肿。

### 为什么只面向 macOS

- 剪贴板集成假定 `pbcopy`/`pbpaste` 存在
- `gx` 映射使用 macOS 的 `open` 命令
- 光标样式和转义序列延迟针对 macOS 终端调优
- 不做跨平台兼容性妥协，把一个平台做到最好

---

## 自定义建议

### 修改缩进

将 4 空格改为 2 空格：

```lua
vim.opt.tabstop     = 2
vim.opt.shiftwidth  = 2
vim.opt.softtabstop = 2
```

### 修改状态栏颜色

编辑 `set_highlights()` 函数中的色值。前景色 (`fg`) 是文字颜色，背景色 (`bg`) 是色块颜色。

### 添加特定语言支持

在配置末尾追加即可，例如添加 gopls：

```lua
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "go", "gomod" },
  callback = function()
    vim.lsp.start({
      name = "gopls",
      cmd  = { "gopls" },
    })
  end,
})
```

### 关闭相对行号

如果不习惯相对行号：

```lua
vim.opt.relativenumber = false
```

或者随时按 `<leader>tn` 临时切换。
