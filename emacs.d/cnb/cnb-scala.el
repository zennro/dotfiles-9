(message (concat "[CNB] - Loading [" load-file-name "]"))

;;;; SCALA

(eval-after-load 'scala-mode2
  '(progn
     (define-key scala-mode-map (kbd "RET") 'reindent-then-newline-and-indent)
     (define-key scala-mode-map (kbd "<backtab>") 'scala-indent:indent-with-reluctant-strategy)

     (add-hook 'scala-mode-hook
               (lambda ()
                 (setq scala-indent:align-parameters t)))))

(provide 'cnb-scala)