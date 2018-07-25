;; use space instead of tab
(setq-default indent-tabs-mode nil)

;; HOME and END on macOS
(global-set-key (kbd "s-<left>") 'move-beginning-of-line)
(global-set-key (kbd "s-<right>") 'move-end-of-line)

;; replace highlighted text when typing AND edit multiple lines at once
(cua-selection-mode 1)

;; use custom auto indent
(electric-indent-mode 0)
(global-set-key (kbd "RET")
  (lambda ()
    (interactive)
    (newline)
    (insert-char ?\s
      (save-excursion
       (forward-line -1)
       (string-match "[^ ]" (thing-at-point 'line))))))

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

;; open recently opened files in ido
(recentf-mode t)
(defun ido-recentf-open ()
  "Use `ido-completing-read' to \\[find-file] a recent file"
  (interactive)
  (if (find-file (ido-completing-read "Find recent file: " recentf-list))
      (message "Opening file...")
    (message "Aborting")))
(global-set-key (kbd "C-x C-r") 'ido-recentf-open)

;; kill the buffer when hitting 'q'
(defadvice quit-window (before quit-window-always-kill)
  "When running 'quit-window', always kill the buffer."
  (ad-set-arg 0 t))
(ad-activate 'quit-window)

;; make dired reuse the same buffer when hitting RET
;; enable 'a' in dired
(put 'dired-find-alternate-file 'disabled nil)
;; overwrite key binding
(add-hook 'dired-mode-hook
  (lambda ()
    (local-set-key (kbd "RET") 'dired-find-alternate-file)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t)
 '(package-selected-packages
   (quote
    (ido-vertical-mode move-text neotree yaml-mode web-mode web-beautify use-package smartparens nyan-mode monokai-theme markdown-mode magit js2-mode highlight-symbol ensime elpy)))
 '(sp-highlight-pair-overlay nil)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ensime-implicit-highlight ((t (:underline (:color "dim gray" :style wave))))))

;; MELPA
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)

(package-initialize)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
;; let use-package install the package automatically
(setq use-package-always-ensure t)

;; ENSIME
(defun scalafmt ()
  (interactive)
  (shell-command
   (format "/usr/local/bin/scalafmt %s"
           (shell-quote-argument (buffer-file-name))))
  (revert-buffer t t t))

(use-package ensime
  :pin melpa-stable
  :init
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

;; web-mode
(use-package web-mode
  :mode
  (("\\.html\\'" . web-mode)
   ("\\.css\\'" . web-mode)))

;; neotree
(use-package neotree
  :init
  (setq neo-theme 'ascii))

;; exec-path-from-shell
(use-package exec-path-from-shell
  :config
  (exec-path-from-shell-initialize))

;; move-text
(use-package move-text
  :config
  (move-text-default-bindings))

;; ido-vertical-mode
(use-package ido-vertical-mode
  :config
  (ido-vertical-mode t)
  (setq ido-vertical-define-keys 'C-n-and-C-p-only))

;;;;;;;

;; natural title bar
(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
(add-to-list 'default-frame-alist '(ns-appearance . dark))

;; remove title and icon on title bar
(setq ns-use-proxy-icon nil)
(setq frame-title-format nil)

;; set a default font
(set-face-attribute 'default nil :font "Monaco-15")

;; fullscreen mode (put this at bottom for mac to work properly)
(toggle-frame-maximized)
