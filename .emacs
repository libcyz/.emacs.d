;;; .emacs --- 入口 -*- lexical-binding: t -*-

(setq custom-file "~/.emacs.d/custom.el")

(load "~/.emacs.rc/rc.el")
(load "~/.emacs.rc/misc-rc.el")

;;; Appearance
(defun rc/set-font (&optional _frame)
  (when (find-font (font-spec :family "Iosevka"))
    (set-face-attribute 'default nil :font "Iosevka-20")))

(rc/set-font)
(add-hook 'after-make-frame-functions #'rc/set-font)   ; emacs --daemon 下新建的窗口

(setq inhibit-startup-screen t)
(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)
(column-number-mode 1)
(show-paren-mode 1)

(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)

(rc/require-theme 'gruber-darker)

;; C-x C-+ / C-x C-- 每级缩放比例，默认 1.2 跳得太大
(setq text-scale-mode-step 1.05)

(rc/require 'smart-mode-line)
(setq sml/no-confirm-load-theme t
      sml/theme 'respectful)
(sml/setup)

(load "~/.emacs.rc/dashboard-rc.el")

;;; Indentation
;; 缩进只用空格；遇到别人文件里的 Tab 按 4 列宽显示
(setq-default indent-tabs-mode nil
              tab-width 4)
(setq-default c-basic-offset 4)
(setq c-ts-mode-indent-offset 4)

;;; tree-sitter：语法高亮改用 *-ts-mode（grammar 装了才切换）
;; 级别越高识别越细（1-4），颜色由主题决定
(setq treesit-font-lock-level 3)

(dolist (remap '((c . ((c-mode . c-ts-mode)
                       (c-or-c++-mode . c-or-c++-ts-mode)))
                 (cpp . ((c++-mode . c++-ts-mode)))
                 (python . ((python-mode . python-ts-mode)))
                 (rust . ((rust-mode . rust-ts-mode)))))
  (when (treesit-language-available-p (car remap))
    (dolist (pair (cdr remap))
      (add-to-list 'major-mode-remap-alist pair))))

;;; Editing
(rc/require 'drag-stuff)
(global-set-key (kbd "<M-up>")   'drag-stuff-up)
(global-set-key (kbd "<M-down>") 'drag-stuff-down)

;;; multiple cursors
(rc/require 'multiple-cursors)

(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->")         'mc/mark-next-like-this)
(global-set-key (kbd "C-<")         'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<")     'mc/mark-all-like-this)
(global-set-key (kbd "C-\"")        'mc/skip-to-next-like-this)
(global-set-key (kbd "C-:")         'mc/skip-to-previous-like-this)

;;; windmove：Shift+方向键切换窗口
(windmove-default-keybindings)

;;; dired
;; 开两个 dired 窗口时，复制/移动的目标默认填另一个窗口的目录
(setq-default dired-dwim-target t)
;; 显示隐藏文件，大小用 K/M/G
(setq dired-listing-switches "-alh")

;;; savehist：记住 M-x 历史，常用命令排在前面
(savehist-mode 1)

;;; ido：M-x、C-x C-f、C-x b 等补全，候选横排显示，C-s / C-r 切换
(rc/require 'ido-completing-read+)
(require 'ido-completing-read+)

;; 模糊匹配：输入 gtr 就能匹配 gt-translate
(setq ido-enable-flex-matching t)

(ido-mode 1)
(ido-everywhere 1)
(ido-ubiquitous-mode 1)   ; 让 M-x 和其它用 completing-read 的地方也走 ido

;;; Company
(rc/require 'company)
(require 'company)

(setq company-minimum-prefix-length 1
      company-idle-delay 0.1
      company-tooltip-align-annotations t
      company-selection-wrap-around t
      company-show-quick-access t)
(global-company-mode 1)

(define-key company-active-map (kbd "C-n")   'company-select-next)
(define-key company-active-map (kbd "C-p")   'company-select-previous)
(define-key company-active-map (kbd "<tab>") 'company-complete-selection)
(define-key company-active-map (kbd "TAB")   'company-complete-selection)

;;; which-key：按 C-c l 后显示 LSP 命令
(require 'which-key)
(which-key-mode 1)

;;; Flycheck：诊断（错误/警告），lsp-mode 会自动对接
(rc/require 'flycheck)
(require 'flycheck)

;;; Rust 主模式（C / Python 用 Emacs 内置的）
(rc/require 'rust-mode)

;;; LSP：打开 C / Rust / Python 文件后自动启动对应语言服务器
(rc/require 'lsp-mode 'lsp-ui 'yasnippet)

;; 前缀必须在加载 lsp-mode 之前设置
(setq lsp-keymap-prefix "C-c l")
(require 'lsp-mode)
(require 'yasnippet)

(setq lsp-idle-delay 0.1
      lsp-auto-guess-root t
      lsp-keep-workspace-alive nil
      lsp-inlay-hint-enable t
      ;; 关掉已过时的 Python 服务器，优先用 pylsp
      lsp-disabled-clients '(pyls mspyls)
      ;; C / C++：clangd
      lsp-clients-clangd-args '("--header-insertion=never"
                                "--clang-tidy"
                                "--background-index")
      ;; Rust：rust-analyzer
      lsp-rust-analyzer-cargo-watch-command "clippy"
      lsp-rust-analyzer-display-chaining-hints t
      lsp-rust-analyzer-display-closure-return-type-hints t)

(dolist (hook '(c-mode-hook c++-mode-hook c-ts-mode-hook c++-ts-mode-hook
                rust-mode-hook rust-ts-mode-hook
                python-mode-hook python-ts-mode-hook))
  (add-hook hook #'lsp-deferred))

(add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)
;; 代码片段：rust-analyzer 的重构/补全需要 yasnippet
(add-hook 'lsp-mode-hook #'yas-minor-mode)

;; 未启动 LSP 时 C-c l 直接启动；启动后由 lsp-mode 的前缀接管
(global-set-key (kbd "C-c l") 'lsp)

;;; magit：C-x g 打开状态窗口
(rc/require 'magit)
(global-set-key (kbd "C-x g") 'magit-status)

;;; 翻译：选中英文后按 C-c t，译文在侧边窗口显示（没有选中时翻译光标处的单词）
(rc/require 'gt)
(require 'gt)

(setq gt-langs '(en zh)
      gt-default-translator
      (gt-translator :engines (gt-bing-engine)
                     :render (gt-buffer-render)))
(global-set-key (kbd "C-c t") 'gt-translate)

;;; Claude Code：C-c C-' 打开菜单，在 Emacs 里运行官方 claude 命令行
;; 终端用 eat（纯 Elisp，不用编译）；通过 MCP 读 flycheck 诊断、xref、treesit，改动用 ediff 审查
(rc/require 'eat)
(rc/require-vc 'claude-code-ide "https://github.com/manzaltu/claude-code-ide.el")
(require 'claude-code-ide)

(setq claude-code-ide-terminal-backend 'eat)
(claude-code-ide-emacs-tools-setup)
(global-set-key (kbd "C-c C-'") 'claude-code-ide-menu)

(when (file-exists-p custom-file)
  (load custom-file nil t))
