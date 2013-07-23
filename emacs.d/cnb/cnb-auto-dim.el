(when (require 'auto-dim-other-buffers nil t)

  (defadvice enable-theme (after my-enable-theme activate)
    (if (string= (ad-get-arg 0) "solarized-dark")
        (set-face-background 'auto-dim-other-buffers-face "#073642")
      (if (string= (ad-get-arg 0) "solarized-light")
          (set-face-background 'auto-dim-other-buffers-face "lightgray"))))

  (turn-on-auto-dim-other-buffers))

(provide 'cnb-auto-dim)
