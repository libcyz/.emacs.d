;;ui配置
;; au-themes 依赖 ef-themes / modus-themes，package-vc 会自动从 GNU ELPA 安装
(use-package au-themes
  :vc (:url "https://github.com/szymonwilczek/au-themes" :rev :newest)
  :demand t
  :config
  ;; 语法高亮换成克制的配色：只保留 3 种强调色，其余用正文色/灰色
  ;; 值可以是主题调色板里的颜色名，也可以直接写 "#rrggbb"
  (setq modus-themes-common-palette-overrides
        '(;; 强调色
          (keyword      green-cooler)   ; 关键字：暗玫瑰
          (preprocessor green-cooler)
          (string       red-warmer)     ; 字符串：鼠尾草绿
          (rx-backslash red-warmer)
          (rx-construct red-warmer)
          (fnname       blue-warmer)    ; 函数定义：琥珀
          ;; 次要信息：比正文略暗的灰绿
          (type         fg-alt)
          (constant     fg-alt)
          (number       fg-alt)
          (comment      fg-dim)
          (docstring    fg-dim)
          ;; 其余一律正文色
          (builtin      fg-main)
          (fnname-call  fg-main)
          (property     fg-main)
          (variable     fg-main)
          (variable-use fg-main)
          (operator     fg-main)
          (bracket      fg-main)
          (delimiter    fg-main)))
  (load-theme 'au-herbarium-night t))

;; 语法高亮：改用 tree-sitter 模式（grammar 由系统 libtree-sitter-* 提供）
;; 级别 4 识别得最细，具体用什么颜色由上面的 overrides 决定
(use-package treesit
  :ensure nil
  :init
  (setq treesit-font-lock-level 3
        major-mode-remap-alist
        (append '((c-mode . c-ts-mode)
                  (c++-mode . c++-ts-mode)
                  (c-or-c++-mode . c-or-c++-ts-mode)
                  (python-mode . python-ts-mode)
                  (rust-mode . rust-ts-mode))
                major-mode-remap-alist)))

;; C-x C-+ / C-x C-- 每级缩放比例，默认 1.2 跳得太大
(setq text-scale-mode-step 1.05)

(use-package smart-mode-line
  :ensure t
  :demand t
  :init
  (setq sml/no-confirm-load-theme t
	sml/theme 'respectful)
  :config
  (sml/setup))

(provide 'init-ui)
