(message (concat "[CNB] - Loading [" load-file-name "]"))

(ignore-errors
  ;;(load-theme 'solarized-dark t)
  ;;(load-theme 'wombat t)
  (load-theme 'zenburn t)
  (set-frame-font "Inconsolata-11" nil t))
  ;;(set-frame-font "Ubuntu Mono-11" nil t))

(menu-bar-mode -1)
(tool-bar-mode -1)

;;(setq redisplay-dont-pause nil) ;; Possibly stop emacs-snapshot from locking up.
(setq redisplay-dont-pause t)

(setq sentence-end-double-space nil)
(setq apropos-do-all t)
(auto-image-file-mode)

;; Reuse existing window for compilation windows.
(setq-default display-buffer-reuse-frames t)

(set-default 'indent-tabs-mode nil)

(set-default 'imenu-auto-rescan t)

(setenv "PAGER" "cat")

(defalias 'yes-or-no-p 'y-or-n-p)

(setq echo-keystrokes 0.1)

(setq confirm-kill-emacs 'y-or-n-p)

(setq completion-cycle-threshold 5)

(when (require 'volatile-highlights nil t)
  (volatile-highlights-mode t))

(setq visible-bell t
      inhibit-startup-message t
      initial-scratch-message nil
      shift-select-mode nil
      mouse-yank-at-point t
      x-select-enable-clipboard t
      x-select-enable-primary t
      save-interprogram-paste-before-kill t
      require-final-newline t
      ediff-window-setup-function 'ediff-setup-windows-plain)

(setq frame-title-format '(buffer-file-name "%f" ("%b")))

(set-default 'cursor-type '(bar . 3))
(set-cursor-color "DarkOrange")

(setq default-frame-alist
  '((cursor-color . "DarkOrange")))

;; Don't let the cursor go into the minibuffer prompt
(setq minibuffer-prompt-properties (quote (read-only t point-entered minibuffer-avoid-prompt face minibuffer-prompt)))

(mouse-avoidance-mode 'exile)

(blink-cursor-mode)
(setq use-file-dialog nil)
(setq use-dialog-box nil)

;;(tooltip-mode 1) ;; Show tooltips in echo area

(when (require 'hilit-chg nil t)
  (setq highlight-changes-visibility-initial-state nil)
  (global-highlight-changes-mode-check-buffers))

;;*==============================================
;; Line wrapping
;;*==============================================
(toggle-truncate-lines 1)
(setq-default truncate-lines t)

;;(setq-default truncate-partial-width-windows t)


;; (when (require 'rainbow-delimiters nil t)
;;   (global-rainbow-delimiters-mode))


(provide 'cnb-ui)
