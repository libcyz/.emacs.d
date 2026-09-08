(use-package drag-stuff
  :bind (("<M-up>" . drag-stuff-up)
         ("<M-down>" . drag-stuff-down)))

;; 自动补全
(use-package company
  :ensure t
  :hook (after-init . global-company-mode)
  :config
  (setq company-minimum-prefix-length 1
        company-idle-delay 0.1
        company-tooltip-align-annotations t
        company-selection-wrap-around t
        company-show-quick-access t)
  :bind (:map company-active-map
              ("C-n" . company-select-next)
              ("C-p" . company-select-previous)
              ("<tab>" . company-complete-selection)
              ("TAB" . company-complete-selection)))

;; 快捷键提示：按 C-c l 后显示 LSP 命令
(use-package which-key
  :ensure t
  :hook (after-init . which-key-mode))

;; 代码片段：rust-analyzer 的重构/补全需要 yasnippet
(use-package yasnippet
  :ensure t
  :hook (lsp-mode . yas-minor-mode))

;; 诊断（错误/警告）。lsp-mode 会自动对接 flycheck
(use-package flycheck
  :ensure t)

;; Rust 主模式（C / Python 用 Emacs 内置的 c-mode / python-mode）
(use-package rust-mode
  :ensure t
  :mode "\\.rs\\'")

;; LSP 客户端：打开 C / Rust / Python 文件后自动启动对应语言服务器
(use-package lsp-mode
  :ensure t
  :init
  ;; 官方推荐前缀，也可用 "C-l"
  (setq lsp-keymap-prefix "C-c l")
  ;; 官方 C/C++ 指南：加大进程读取缓冲，避免 clangd 等高产出服务器卡顿
  (setq read-process-output-max (* 1024 1024))
  ;; 图形界面启动的 Emacs 经常没有 ~/.local/bin，会找不到语言服务器
  (dolist (dir '("~/.local/bin" "~/.cargo/bin"))
    (let ((path (expand-file-name dir)))
      (when (file-directory-p path)
        (add-to-list 'exec-path path)
        (unless (string-match-p (regexp-quote path) (or (getenv "PATH") ""))
          (setenv "PATH" (concat path path-separator (getenv "PATH")))))))
  :hook ((c-mode . lsp-deferred)
         (c++-mode . lsp-deferred)
         (c-ts-mode . lsp-deferred)
         (c++-ts-mode . lsp-deferred)
         (rust-mode . lsp-deferred)
         (rust-ts-mode . lsp-deferred)
         (python-mode . lsp-deferred)
         (python-ts-mode . lsp-deferred)
         (lsp-mode . lsp-enable-which-key-integration))
  :commands (lsp lsp-deferred)
  :config
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
        lsp-rust-analyzer-display-closure-return-type-hints t))

;; 可选 UI：悬停文档、侧边诊断、定义/引用预览
(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode)

(use-package nerd-icons
  :ensure t)

;; VS Code 风格的侧边栏文件树
(use-package treemacs
  :ensure t
  :bind (("C-x t t" . treemacs)
         ("C-c t" . treemacs-select-window)
         ([f8] . treemacs))
  :config
  (setq treemacs-width 28
        treemacs-indentation 1
        treemacs-display-in-side-window t
        treemacs-follow-after-init t
        treemacs-user-mode-line-format 'none
        treemacs-user-header-line-format 'none)
  (treemacs-follow-mode t)
  (treemacs-filewatch-mode t)
  (treemacs-git-mode 'deferred)
  (treemacs-project-follow-mode t)
  ;; 用更紧凑的 nerd-icons，替换默认 22px PNG
  (require 'treemacs-nerd-icons)
  (treemacs-nerd-icons-config))

(use-package treemacs-nerd-icons
  :ensure t
  :after treemacs)

;; LSP 的错误列表、符号树也进 treemacs
(use-package lsp-treemacs
  :ensure t
  :after lsp-mode
  :commands lsp-treemacs-errors-list)

(provide 'init-package)
