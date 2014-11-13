(message (concat "[CNB] - Loading [" load-file-name "]"))

(when (require 'projectile nil t)
  (require 'f nil t) ;; Projectile doesn't do this.

  ;;(require 'grizzl)
  (projectile-global-mode)
  ;;(setq projectile-enable-caching t)
  (setq projectile-completion-system 'helm)
  ;;(setq projectile-completion-system 'grizzl)
  ;; Press Command-p for fuzzy find in project
  ;; Press Command-b for fuzzy switch buffer

  (when (require 'projectile-rails nil t)
    (add-hook 'projectile-mode-hook 'projectile-rails-on)))

(provide 'cnb-projectile)
