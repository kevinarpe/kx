(setq explicit-cmdproxy.exe-args '("/q"))

(defun switch-to-previous-buffer ()
  "Switch to the previous buffer"
  (interactive)
  (switch-to-buffer (other-buffer)))

(fset 'kcopy
   [0 f7 23 25 end 25 f8])

(fset 'switch-to-buffer-return
   [-8388488 115 119 105 116 99 104 45 116 111 45 98 117 102 102 101 114
return return])

(global-set-key [f1]  'goto-line)
(global-set-key [f2]  'find-file)
(global-set-key [f3]  'write-file)
(global-set-key [f4]  'bury-buffer)
(global-set-key [f5]  'advertised-undo)
(global-set-key [f6]  'fundamental-mode)
(global-set-key [f7]  'beginning-of-line)
(global-set-key [f8]  'end-of-line)
(global-set-key [f9]  'split-window-vertically)
(global-set-key [f10] 'delete-other-windows)
(global-set-key [f11] 'other-window)
(global-set-key [f12] 'switch-to-previous-buffer)

(global-set-key [mouse-3] 'kcopy)

(setq shell-prompt-pattern ">+")

(setq auto-save-mode 0)

(setq mail-self-blind t)

(put 'eval-expression 'disabled nil)

(setq message-log-max nil)
(kill-buffer "*Messages*")

(setq default-frame-alist '((width . 80) (height . 46)))