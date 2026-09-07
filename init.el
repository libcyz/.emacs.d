;;初始化设置
(add-to-list 'load-path
	     (expand-file-name(concat user-emacs-directory "lisp")))

(require 'init-epla)
(require 'init-ui)
(require 'init-startup)
