;;; early-init.el --- 第一帧创建前的设置 -*- lexical-binding: t -*-

;; GTK 标题栏跟随深色主题（必须在第一帧创建前设置，放 .emacs 里来不及）
(setenv "GTK_THEME" "Adwaita:dark")
