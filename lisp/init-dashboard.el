;;; init-dashboard.el --- 启动首页 -*- lexical-binding: t -*-

;; C-c e 打开 Emacs Lisp 参考手册
(global-set-key (kbd "C-c e") (lambda () (interactive) (info "elisp")))

;; 底部快捷键：两行，每行 3 个
(defconst my/dashboard-keys
  '(("C-x g" . "Magit")    ("C-c e" . "Lisp手册") ("C-c d" . "回首页")
    ("M-."   . "跳到定义") ("M-,"   . "跳回来") ("M-;"   . "注释")))

(defun my/dashboard-insert-keys ()
  (insert "\n")
  (let ((i 0) line lines)
    (dolist (k my/dashboard-keys)
      (push (concat (propertize (format "%-8s" (car k)) 'face 'font-lock-keyword-face)
                    (propertize (truncate-string-to-width (cdr k) 12 nil ?\s) 'face 'shadow))
            line)
      (when (= (% (setq i (1+ i)) 3) 0)
        (push (string-join (nreverse line) "") lines)
        (setq line nil)))
    (dolist (l (nreverse lines))
      (dashboard-insert-center l "\n"))))

(use-package dashboard
  :demand t
  :bind ("C-c d" . dashboard-open)
  :init
  (setq dashboard-startup-banner (expand-file-name "lisp.jpg" user-emacs-directory)
        dashboard-image-banner-max-height 260
        dashboard-center-content t
        dashboard-vertically-center-content t
        dashboard-show-shortcuts t
        dashboard-items '((recents  . 6)
                          (bookmarks . 3))
        dashboard-startupify-list '(dashboard-insert-banner
                                    dashboard-insert-newline
                                    dashboard-insert-init-info
                                    dashboard-insert-items
                                    dashboard-insert-newline
                                    my/dashboard-insert-keys))
  :config
  (recentf-mode 1)   ; 否则 Recent Files 永远是空的
  (dashboard-setup-startup-hook)
  ;; 首页不需要行号
  (add-hook 'dashboard-mode-hook (lambda () (display-line-numbers-mode -1))))

(provide 'init-dashboard)
