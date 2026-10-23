;;; rc.el --- 装包用的小工具 -*- lexical-binding: t -*-

(require 'package)

(setq package-check-signature nil)
(setq package-archives
      '(("gnu"    . "https://mirrors.ustc.edu.cn/elpa/gnu/")
        ("nongnu" . "https://mirrors.ustc.edu.cn/elpa/nongnu/")
        ("melpa"  . "https://mirrors.ustc.edu.cn/elpa/melpa/")))

(defvar rc/package-contents-refreshed nil)

(defun rc/package-refresh-contents-once ()
  (when (not rc/package-contents-refreshed)
    (setq rc/package-contents-refreshed t)
    (package-refresh-contents)))

(defun rc/require-one-package (package)
  (when (not (package-installed-p package))
    (rc/package-refresh-contents-once)
    (package-install package)))

;; 没装就装，装了什么也不做：(rc/require 'magit 'company)
(defun rc/require (&rest packages)
  (dolist (package packages)
    (rc/require-one-package package)))

;; (rc/require-theme 'gruber-darker) 会装 gruber-darker-theme 并加载
(defun rc/require-theme (theme)
  (rc/require (intern (concat (symbol-name theme) "-theme")))
  (load-theme theme t))
