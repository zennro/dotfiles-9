(message (concat "[CNB] - Loading [" load-file-name "]"))

(use-package ruby-mode
  :ensure ruby-mode
  :init
  (progn
    (setq imenu-generic-expression
          '(("Methods"  "^\\( *\\(def\\) +.+\\)"          1)))
    (yard-mode)
    (outline-minor-mode)
    (when (featurep 'ruby-block)
      (ruby-block-mode t))
    (when (featurep 'flymake-ruby)
      (flymake-ruby-load))

    (setq-local prettify-symbols-alist '(("lambda"  . ?λ)))

    ;; I use C-x t for toggling globally
    (define-key ruby-mode-map "\C-xt" nil)

    (ignore-errors (ruby-refactor-mode-launch)


   )
    )

(use-package rvm
  :ensure rvm
  :init
  (progn
    (rvm-autodetect-ruby)))

;;(add-hook 'projectile-mode-hook 'projectile-rails-on)
(require 'rspec-mode nil t)
(require 'flymake-ruby nil t)

(eval-after-load 'ruby-refactor-mode
  '(progn (diminish 'ruby-refactor-mode "RR")))

(defun cnb/ruby-setup ()
    ;; (set (make-local-variable imenu-generic-expression)
  ;;      '(("Methods"  "^\\( *\\(def\\) +.+\\)"          1)
  ;;        ))
  ;;(subword-mode +1)
  (robe-mode)
  (setq outline-regexp " *\\(def \\|class\\|module\\|describe \\|it \\)")))

(when (require 'ruby-mode nil t)
  (when (require 'robe-mode nil t)
    (add-hook 'robe-mode-hook 'robe-ac-setup))

  (define-key ruby-mode-map (kbd "RET") 'newline-and-indent)


  (add-to-list 'auto-mode-alist '("Capfile$" . ruby-mode))
  (add-to-list 'auto-mode-alist '("Gemfile$" . ruby-mode))
  (add-to-list 'auto-mode-alist '("Rakefile$" . ruby-mode))
  (add-to-list 'auto-mode-alist '("Vagrantfile$" . ruby-mode))
  (add-to-list 'auto-mode-alist '("\\.gemspec$" . ruby-mode))
  (add-to-list 'auto-mode-alist '("\\.prawn$" . ruby-mode))
  (add-to-list 'auto-mode-alist '("\\.rake$" . ruby-mode))
  (add-to-list 'auto-mode-alist '("\\.rjs$" . ruby-mode))
  (add-to-list 'auto-mode-alist '("\\.ru$" . ruby-mode))
  (add-to-list 'auto-mode-alist '("\\.rb$" . ruby-mode))

  (add-hook 'ruby-mode-hook 'cnb/ruby-setup))


(provide 'cnb-ruby)
