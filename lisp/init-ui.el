
;;ui配置
(use-package catppuccin-theme
  :ensure t
  :demand t
  :config
  (setq catppuccin-flavor 'frappe)
  (load-theme 'catppuccin t))

(use-package smart-mode-line
  :ensure t
  :demand t
  :init
  (setq sml/no-confirm-load-theme t
	sml/theme 'respectful)
  :config
  (sml/setup))

(provide 'init-ui)
