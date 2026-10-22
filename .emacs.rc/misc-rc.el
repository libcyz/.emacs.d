;;; misc-rc.el --- 编码、PATH、剪贴板 -*- lexical-binding: t -*-

(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)

;; 图形界面启动的 Emacs 经常没有这些目录
(dolist (dir '("~/.local/bin" "~/.cargo/bin"))
  (let ((path (expand-file-name dir)))
    (when (file-directory-p path)
      (add-to-list 'exec-path path)
      (unless (string-match-p (regexp-quote path) (or (getenv "PATH") ""))
        (setenv "PATH" (concat path path-separator (getenv "PATH")))))))

;; 剪贴板：Linux 上通过 wl-copy / xclip 与系统剪贴板同步（文本经 stdin 传入）
;; Windows 用 Emacs 自带的剪贴板支持，不需要这段
(setq select-enable-clipboard t)

(defun rc/clipboard-copy-command ()
  (cond ((executable-find "wl-copy") '("wl-copy"))
        ((executable-find "xclip") '("xclip" "-selection" "clipboard"))))

(defun rc/clipboard-copy (text)
  "用 wl-copy 或 xclip 把 TEXT 复制到系统剪贴板。"
  (let ((proc (make-process :name "clipboard-copy"
                            :command (rc/clipboard-copy-command)
                            :buffer nil
                            :connection-type 'pipe
                            :noquery t)))
    (process-send-string proc text)
    (process-send-eof proc)))

(when (and (eq system-type 'gnu/linux) (rc/clipboard-copy-command))
  (setq interprogram-cut-function #'rc/clipboard-copy))
