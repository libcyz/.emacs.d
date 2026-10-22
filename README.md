# dotfiles

我的 Emacs 配置。风格参考 [rexim/dotfiles](https://github.com/rexim/dotfiles)：不用 use-package，缺包自动装，启动时全部加载。

## 安装

需要 Emacs 30+。

```bash
git clone <这个仓库> ~/dotfiles
cd ~/dotfiles
./deploy.sh          # Windows: .\deploy.ps1
```

脚本按 `MANIFEST` 把文件软链接到家目录：

| 仓库里 | 链接到 |
|---|---|
| `.emacs` | `~/.emacs` |
| `.emacs.rc/` | `~/.emacs.rc/` |
| `early-init.el` | `~/.emacs.d/early-init.el` |

目标位置已有同名的普通文件时脚本会停下，需要先手动挪走。Windows 上建软链接要管理员权限，或打开"开发人员模式"。

第一次启动 Emacs 会自动装包，要等一会儿。

可选依赖：

- **Iosevka 字体**：装了就用 `Iosevka-20`，没装就用默认字体
- **Claude Code**：`claude` 命令要在 PATH 里
- **语言服务器**：`clangd`（C/C++）、`rust-analyzer`、`pylsp`（Python）

## 文件

```
.emacs              主配置：外观、编辑、各个包
.emacs.rc/rc.el     rc/require 等装包函数、软件源
.emacs.rc/misc-rc.el       编码、PATH、Linux 剪贴板
.emacs.rc/dashboard-rc.el  启动首页
```

加新包的写法：

```elisp
(rc/require 'some-package)   ; 没装就装
(require 'some-package)
```

## 快捷键

只列我自己加的或改过的。

| 按键 | 作用 |
|---|---|
| `C-c d` | 回到首页 |
| `C-c e` | 打开 Emacs Lisp 手册 |
| `C-c t` | 翻译选中的文字（没选中就翻译光标处的词） |
| `C-x g` | Magit |
| `C-c l` | 启动 LSP；启动后是 LSP 命令前缀，停一下会弹出提示 |
| `M-.` / `M-,` | 跳到定义 / 跳回来 |
| `C-c C-'` | Claude Code 菜单（见下文） |
| `Shift + 方向键` | 切换窗口 |
| `M-↑` / `M-↓` | 把当前行（或选区）上下移动 |
| `C-x C-+` / `C-x C--` | 放大 / 缩小字体，每级 5% |

### 多光标

最常用的是"选中一个词，再一个个加上相同的词"：

1. 选中一个词（比如变量名 `count`）
2. 按 `C->`，下一个 `count` 也被选中，多出一个光标
3. 继续按 `C->` 加更多；某个不想要就按 `C-"` 跳过
4. 直接打字，所有光标一起改
5. 按 `C-g` 退出

| 按键 | 作用 |
|---|---|
| `C->` / `C-<` | 加上下一个 / 上一个相同的内容 |
| `C-"` / `C-:` | 跳过下一个 / 上一个 |
| `C-c C-<` | 一次选中所有相同的内容 |
| `C-S-c C-S-c` | 选中几行后按，每行一个光标 |

第一次在多光标下执行某个命令时，会问你"要不要对所有光标都执行"，答案会记在 `~/.emacs.d/.mc-lists.el`。

### Claude Code

用的是 [claude-code-ide.el](https://github.com/manzaltu/claude-code-ide.el)：在 Emacs 里开一个 [eat](https://codeberg.org/akib/emacs-eat) 终端运行官方 `claude` 命令，界面和终端里用的一样。Claude 还能读到 Emacs 里的报错（flycheck）、跳转定义（xref）和语法树（tree-sitter）。

**开始**：在项目里任意文件中按 `C-c C-'`，再按 `s`，右边会打开 Claude 窗口。

**菜单里常用的**（都是 `C-c C-'` 后再按）：

| 键 | 作用 |
|---|---|
| `s` | 启动（这个项目已经在运行就跳过去） |
| `c` / `r` | 接着上次的对话 / 选一个历史对话恢复 |
| `w` | 显示 / 隐藏 Claude 窗口 |
| `b` | 跳到 Claude 窗口 |
| `i` | 把选中的代码发给 Claude |
| `p` | 在小缓冲区里写一句话发给 Claude |
| `e` | 发送 Esc（打断 Claude） |
| `n` | 在输入框里换行而不发送 |
| `q` | 关掉这个项目的 Claude |

**在 Claude 窗口里**，终端默认处于"半字符模式"：大部分按键直接发给 Claude，但 Emacs 的常用键照样能用。

| 想做的事 | 怎么按 |
|---|---|
| 切换 buffer / 窗口 | `C-x b`、`C-x o`、`Shift + 方向键`，和平时一样 |
| `M-x` | 照常可用 |
| 粘贴 | `C-y`；`M-y` 从以前复制过的内容里挑一个 |
| 复制 Claude 的输出 | `C-c C-e` 进入 Emacs 模式，像普通 buffer 一样移动、选中、`M-w`，再按 `C-c C-j` 回去打字 |
| 给终端发 `Ctrl-C` | `C-c C-c` |

**审查修改**：Claude 要改文件时会自动打开 ediff，左边是原文件，右边是 Claude 的版本。

- `n` / `p`：跳到下一处 / 上一处修改
- 右边那个 buffer 可以直接编辑，改完再接受
- `q` 退出，然后问你接不接受：按 `y` 应用，按 `n` 拒绝

> Claude 默认能在你的 Emacs 里执行 Elisp。不放心的话在 `.emacs` 里加 `(setq claude-code-ide-enable-execute-code nil)`。

### 补全（ido）

`M-x`、`C-x C-f`、`C-x b` 都用 ido：候选横排在底部，支持模糊匹配（输入 `gtr` 能匹配到 `gt-translate`）。

- `C-s` / `C-r`：在候选之间左右切换
- `RET`：选中
- 在 `C-x C-f` 里按 `C-f`：退回普通的文件补全（想新建一个和现有文件名字很像的文件时用）
- 在 `C-x C-f` 里按 `C-d`：用 dired 打开当前目录

### dired

开两个 dired 窗口，在一边按 `C`（复制）或 `R`（移动），目标会自动填成另一边的目录。

## 其他设置

- 缩进只用空格，C 代码缩进 4 格，Tab 字符按 4 列宽显示
- 相对行号，模式栏显示列号
- C / C++ / Python / Rust 用 tree-sitter 高亮（系统里装了对应的 grammar 才启用）
- 打开这几种语言的文件时会自动启动 LSP

## 常见问题

**启动时报 `GnuTLS error` 或装包卡住**：软件源镜像（USTC）连不上。改 `.emacs.rc/rc.el` 里的 `package-archives`，换成官方源或其他镜像。

**`deploy.sh` 报 `exists but it's not a symlink`**：家目录里已经有一个普通的 `.emacs` 之类的文件，先把它挪走再运行。
