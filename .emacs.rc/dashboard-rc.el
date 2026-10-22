;;; dashboard-rc.el --- 启动首页 -*- lexical-binding: t -*-

(rc/require 'dashboard)
(require 'dashboard)

;; C-c e 打开 Emacs Lisp 参考手册
(global-set-key (kbd "C-c e") (lambda () (interactive) (info "elisp")))

;; 底部快捷键：两行，每行 3 个
(defconst rc/dashboard-keys
  '(("C-x g" . "Magit")    ("C-c e" . "Lisp手册") ("C-c d" . "回首页")
    ("M-."   . "跳到定义") ("M-,"   . "跳回来") ("C-c t"   . "翻译")))

(defun rc/dashboard-insert-keys ()
  (insert "\n")
  (let ((i 0) line lines)
    (dolist (k rc/dashboard-keys)
      (push (concat (propertize (format "%-8s" (car k)) 'face 'font-lock-keyword-face)
                    (propertize (truncate-string-to-width (cdr k) 12 nil ?\s) 'face 'shadow))
            line)
      (when (= (% (setq i (1+ i)) 3) 0)
        (push (string-join (nreverse line) "") lines)
        (setq line nil)))
    (dolist (l (nreverse lines))
      (dashboard-insert-center l "\n"))))

(setq dashboard-startup-banner "~/.emacs.rc/lisp.jpg"
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
                                  rc/dashboard-insert-keys))

(recentf-mode 1)   ; 否则 Recent Files 永远是空的
(dashboard-setup-startup-hook)
(global-set-key (kbd "C-c d") 'dashboard-open)

;; 首页不需要行号
(add-hook 'dashboard-mode-hook (lambda () (display-line-numbers-mode -1)))

;; 不要默认进 *scratch*：有命令行文件就打开文件，否则打开首页
(setq initial-scratch-message nil)

(defun rc/initial-buffer ()
  (or (catch 'found
        (dolist (buf (buffer-list))
          (when (buffer-file-name buf)
            (throw 'found buf))))
      (progn (dashboard-refresh-buffer) (get-buffer "*dashboard*"))))

(setq initial-buffer-choice #'rc/initial-buffer)
