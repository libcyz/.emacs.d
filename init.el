;;; init.el --- 入口 -*- lexical-binding: t -*-

(add-to-list 'load-path
             (expand-file-name "lisp" user-emacs-directory))

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

(require 'init-const)
(require 'init-epla)
(require 'init-startup)
(require 'init-ui)
(require 'init-package)

(when (file-exists-p custom-file)
  (load custom-file nil t))

;; 启动完成后恢复合理 GC，避免内存一直涨
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 100 1024 1024)
                  gc-cons-percentage 0.1)
            (when (boundp 'my/file-name-handler-alist)
              (setq file-name-handler-alist my/file-name-handler-alist))))
