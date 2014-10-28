(message (concat "[CNB] - Loading [" load-file-name "]"))

;;;; GIT


(when (require 'git-gutter nil t)
  (git-gutter:linum-setup)
  (global-git-gutter-mode +1))

(when (require 'magit nil t)
  (add-hook 'magit-status-mode-hook
            (lambda ()
              (visual-line-mode -1)))

  (setq magit-diff-refine-hunk t)
  (setq magit-process-popup-time 60)

  (if git-rebase-mode-map
      (progn
        (define-key git-rebase-mode-map (kbd "M-d") 'git-rebase-move-line-down)
        (define-key git-rebase-mode-map (kbd "M-u") 'git-rebase-move-line-up)))

  ;; Show magit-status in full window and restore window config on quit.
  ;; (defadvice magit-status (around magit-fullscreen activate)
  ;;   (window-configuration-to-register :magit-fullscreen)
  ;;   ad-do-it
  ;;   (delete-other-windows))

  ;; (defun magit-quit-session ()
  ;;   "Restores the previous window configuration and kills the magit buffer"
  ;;   (interactive)
  ;;   (kill-buffer)
  ;;   (jump-to-register :magit-fullscreen))

  ;; (define-key magit-status-mode-map (kbd "q") 'magit-quit-session)

  (defun magit-toggle-whitespace ()
    (interactive)
    (if (member "-w" magit-diff-options)
        (magit-dont-ignore-whitespace)
      (magit-ignore-whitespace)))

  (defun magit-ignore-whitespace ()
    (interactive)
    (add-to-list 'magit-diff-options "-w")
    (magit-refresh))

  (defun magit-dont-ignore-whitespace ()
    (interactive)
    (setq magit-diff-options (remove "-w" magit-diff-options))
    (magit-refresh))

  (if magit-status-mode-map
      (define-key magit-status-mode-map (kbd "W") 'magit-toggle-whitespace))

  (add-hook 'magit-log-edit-mode-hook 'flyspell-mode)
  (add-hook 'git-commit-mode-hook 'flyspell-mode)

  ;;(eval-after-load 'magit
    ;;'(progn
       ;;(set-face-foreground 'magit-section-title "blue")))
       ;;(set-face-foreground 'magit-branch "orange")
       ;;(set-face-foreground 'magit-diff-add "green3")))

  (global-set-key (kbd "C-c g") 'magit-status))

(defun cnb/git-msg-popup-hook ()
  (magit-commit-mode))

(when (require 'git-messenger nil t)
  (setq git-messenger:show-detail t)
  (add-hook 'git-messenger:popup-buffer-hook 'cnb/git-msg-popup-hook)
  (global-set-key (kbd "C-x v p") 'git-messenger:popup-message))

(provide 'cnb-sc)
