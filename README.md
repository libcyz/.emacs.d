# dotfiles

我的 Emacs 配置，参考 [rexim/dotfiles](https://github.com/rexim/dotfiles)：不用 use-package，缺什么包启动时自动安装，全部一次加载。

## 文件结构

主配置是 `.emacs`，外观、编辑习惯和各个包都在里面。`.emacs.rc/` 放拆出去的部分：`rc.el` 是装包用的 `rc/require` 函数和软件源，`misc-rc.el` 编码、PATH 和 Linux 剪贴板，`dashboard-rc.el` 是启动首页。`MANIFEST` 写明哪些文件要链接到家目录，`deploy.sh` 和 `deploy.ps1` 按它去链接。

## 安装

需要 Emacs 30 以上。

```bash
git clone <这个仓库> ~/dotfiles
cd ~/dotfiles
./deploy.sh        # Windows 用 .\deploy.ps1
```

然后打开 Emacs，第一次启动会自动装包，等它装完即可。

如果脚本提示某个文件已存在，说明家目录里已经有旧的 `.emacs` 等文件，挪走再运行一次。Windows 上创建软链接需要管理员权限，或者打开"开发人员模式"。

## 包和快捷键

**gruber-darker-theme**：配色主题。

**smart-mode-line**：更紧凑的底部状态栏。

**ido**（自带）+ **ido-completing-read+**：`M-x`、`C-x C-f`、`C-x b` 的候选横排在底部，支持模糊匹配（输入 `gtr` 能找到 `gt-translate`）。`C-s` / `C-r` 左右切换候选，`RET` 选中。在 `C-x C-f` 里按 `C-f` 退回普通文件补全，按 `C-d` 用 dired 打开当前目录。

**multiple-cursors**：多光标。选中一个词后按 `C->`，下一个相同的词也会被选中并多出一个光标，继续按就继续加，`C-"` 跳过不想要的那个，然后直接打字就是同时修改，`C-g` 退出。`C-<` 往上找，`C-c C-<` 一次选中全部。选中几行后按 `C-S-c C-S-c`，每行放一个光标。

**drag-stuff**：`M-↑` / `M-↓` 把当前行或选中的几行上下移动。

**company**：自动补全，输入一个字符就弹出。`C-n` / `C-p` 上下选，`Tab` 确认。

**lsp-mode** + **lsp-ui**：打开 C/C++、Rust、Python 文件时自动连接语言服务器（需要自己装 `clangd`、`rust-analyzer`、`pylsp`）。`M-.` 跳到定义，`M-,` 跳回来。`C-c l` 是 LSP 命令的前缀，比如 `C-c l r r` 重命名，`C-c l a a` 代码操作，`C-c l = =` 格式化；按下 `C-c l` 停一下，which-key（自带）会列出所有可用命令。

**flycheck**：显示错误和警告。`C-c ! n` / `C-c ! p` 跳到下一个 / 上一个错误，`C-c ! l` 列出全部。

**yasnippet**：代码片段，LSP 补全时会用到，补全出的片段按 `Tab` 跳到下一个要填的位置。

**rust-mode**：Rust 支持。

**magit**：Git 界面，`C-x g` 打开。

**gt**：翻译，选中英文后按 `C-c t`，译文显示在侧边窗口；没选中就翻译光标处的词。

还有几个自带功能：`Shift + 方向键` 在窗口之间切换（windmove）；开两个 dired 窗口时按 `C` 复制或 `R` 移动，目标会自动填成另一个窗口的目录；savehist 会记住 `M-x` 的历史。


