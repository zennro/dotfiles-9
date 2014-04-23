(message (concat "[CNB] - Loading [" load-file-name "]"))

(setq dired-listing-switches "-alFh")
(setq dired-dwim-target t)

;;(load "dired-x")
(add-hook 'dired-load-hook
          (lambda ()
            (load "dired-x")))

;;(add-hook 'dired-mode-hook 'turn-on-auto-revert-mode)

(setq dired-recursive-copies 'always)
(setq dired-recursive-deletes 'always)

(defun cnb-dired-back-to-top ()
  "Move to the first file name in the dired buffer"
  (interactive)

  ; If dired-hide-details-mode enabled then there are 3 lines of
  ; headings, else 4 lines.
  (let (line-nbr)
    (if (and (boundp 'dired-hide-details-mode) dired-hide-details-mode)
        (setq line-nbr 3)
      (setq line-nbr 4))
    (beginning-of-buffer)
    (dired-next-line line-nbr)))

(defun cnb-dired-jump-to-bottom ()
  "Jump to last file in dired buffer"
  (interactive)
  (end-of-buffer)
  (dired-next-line -1))

(when (boundp 'dired-mode-map)
  ;; Change M-< instead of moving to the dired headings move to the first
  ;; file name.
  (define-key dired-mode-map
    (vector 'remap 'beginning-of-buffer) 'cnb-dired-back-to-top)
  (define-key dired-mode-map
    (vector 'remap 'end-of-buffer) 'cnb-dired-jump-to-bottom))

;; Change M-> instead of moving to empty line at bottom  move to the last
;; file name.

;; Allow <ALT>o to omit hidden files
(require 'dired-x)
(setq dired-omit-files
      (concat dired-omit-files "\\|^\\..+$"))


(setq wdired-allow-to-change-permissions 't)
(setq wdired-confirm-overwrite 't)

(global-set-key (kbd "C-c C-d") 'dired-jump)

(provide 'cnb-dired)
