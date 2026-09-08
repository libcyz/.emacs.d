;;; init-epla.el --- 软件源 -*- lexical-binding: t -*-

(setq package-check-signature nil)
(require 'package)

(setq package-archives
      '(("gnu"    . "https://mirrors.ustc.edu.cn/elpa/gnu/")
        ("nongnu" . "https://mirrors.ustc.edu.cn/elpa/nongnu/")
        ("melpa"  . "https://mirrors.ustc.edu.cn/elpa/melpa/")))

(setq package-quickstart t)

(unless (bound-and-true-p package--initialized)
  (package-initialize))

;; 只在本地没有软件源索引时刷新，避免每次启动联网
(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

;; 新装包后重建 quickstart，否则下次启动会丢 autoload
(defun my/refresh-package-quickstart (&rest _)
  (when package-quickstart
    (package-quickstart-refresh)))
(advice-add 'package-install :after #'my/refresh-package-quickstart)

(setq use-package-always-ensure t
      use-package-always-defer t
      use-package-always-demand nil
      use-package-expand-minimally t
      use-package-verbose nil)
(require 'use-package)

(provide 'init-epla)
