(message (concat "[CNB] - Loading [" load-file-name "]"))

(require 'uniquify)

(setq uniquify-buffer-name-style 'post-forward-angle-brackets)
(setq uniquify-after-kill-buffer-p t)    ; rename after killing uniquified
(setq uniquify-ignore-buffers-re "^\\*") ; don't muck with special buffers

(provide 'cnb-uniquify)
