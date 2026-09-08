;;; init-startup.el --- 启动配置 -*- lexical-binding: t -*-

(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)

(tool-bar-mode -1)
(scroll-bar-mode -1)
(global-display-line-numbers-mode 1)

;; 图形界面启动的 Emacs 经常没有这些目录
(dolist (dir '("~/.local/bin" "~/.cargo/bin"))
  (let ((path (expand-file-name dir)))
    (when (file-directory-p path)
      (add-to-list 'exec-path path)
      (unless (string-match-p (regexp-quote path) (or (getenv "PATH") ""))
        (setenv "PATH" (concat path path-separator (getenv "PATH")))))))

(provide 'init-startup)
