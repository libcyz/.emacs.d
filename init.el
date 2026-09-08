;;初始化设置
(add-to-list 'load-path
             (expand-file-name "lisp" user-emacs-directory))

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

(require 'init-const)
(require 'init-epla)
(require 'init-ui)
(require 'init-startup)
(require 'init-package)
