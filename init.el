;; use space instead of tab
(setq-default indent-tabs-mode nil)

;; use custom auto indent
(electric-indent-mode 0)
(global-set-key (kbd "RET")
  (lambda ()
    (interactive)
    (newline)
    (if (save-excursion (re-search-backward "^[^\n]" nil t))
      (indent-relative-maybe))))

;; disable auto-save and auto-backup
(setq auto-save-default nil)
(setq make-backup-files nil)

;; add newline to the end of the line by default
(setq require-final-newline t)

;; delete trailing whitespaces on save
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; scroll one line at a time
(setq scroll-step 1)
(setq scroll-conservatively 10000)

;; hide scrollbar
(scroll-bar-mode -1)

;; make buffer switch command auto suggestions, also for find-file command
(ido-mode 1)

;; kill the buffer when hitting 'q'
(defadvice quit-window (before quit-window-always-kill)
  "When running 'quit-window', always kill the buffer."
  (ad-set-arg 0 t))
(ad-activate 'quit-window)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t)
 '(js2-include-node-externs t)
 '(js2-strict-missing-semi-warning nil)
 '(package-selected-packages
   (quote
    (nyan-mode yaml-mode web-beautify use-package smartparens js2-mode highlight-symbol elpy)))
 '(sp-highlight-pair-overlay nil)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ensime-implicit-highlight ((t (:underline (:color "dim gray" :style wave)))))
 '(js2-error ((t (:underline (:color "red" :style wave)))))
 '(js2-external-variable ((t (:underline (:color "red" :style wave))))))

;; MELPA
(require 'package)
(setq
 use-package-always-ensure t
 package-archives '(("melpa" . "http://melpa.org/packages/")
                    ("melpa-stable" . "http://stable.melpa.org/packages/")))

(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

;; ENSIME
(use-package ensime
  :ensure t
  :pin melpa
  :init
  (add-to-list 'exec-path "/usr/local/bin")
  (setq ensime-startup-notification nil)
  (setq ensime-startup-snapshot-notification nil))

;; smartparens
(use-package smartparens
  :init
  (require 'smartparens-config)
  :bind
  ("C-R" . sp-rewrap-sexp)
  :config
  (smartparens-global-mode t)
  (show-smartparens-global-mode t))

;; markdown-mode
(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

;; web-beautify
(use-package web-beautify)

;; elpy
(use-package elpy
  :config
  (elpy-enable))

;; highlight-symbol
(use-package highlight-symbol
  :bind
  (("<C-f3>" . highlight-symbol)
   ("<f3>" . highlight-symbol-next)))

;; yaml mode
(use-package yaml-mode)

;; js2-mode
(use-package js2-mode
  :init
  (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
  :config
  (add-hook 'js2-mode-hook 'company-mode))

;; magit
(use-package magit
  :bind
  ("C-x g" . magit-status))

;; monokai-theme
(use-package monokai-theme
  :init
  (load-theme 'monokai t))

;; nyan-mode
(use-package nyan-mode
  :init
  (nyan-mode t)
  (setq nyan-bar-length 20)
  (nyan-start-animation))

;;;;;;;

;; set a default font
(set-face-attribute 'default nil :font "Monaco-15")

;; fullscreen mode (put this at bottom for mac to work properly)
(toggle-frame-maximized)
