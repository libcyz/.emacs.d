;;; early-init.el --- 启动早期优化 -*- lexical-binding: t -*-

;; 启动阶段几乎不 GC，结束后再恢复
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

;; 自己在 init-epla.el 里初始化，并走 package-quickstart
(setq package-enable-at-startup nil
      package-quickstart t)

(setq frame-inhibit-implied-resize t
      inhibit-compacting-font-caches t
      read-process-output-max (* 1024 1024)
      native-comp-async-report-warnings-errors 'silent
      inhibit-startup-screen t
      inhibit-startup-message t)

;; 第一帧就不要工具栏/滚动条，避免先画出来再关掉
(setq default-frame-alist
      (append '((tool-bar-lines . 0)
                (vertical-scroll-bars . nil)
                (horizontal-scroll-bars . nil))
              default-frame-alist))

;; 启动时跳过特殊文件名处理，结束后恢复
(defvar my/file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)
