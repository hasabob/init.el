;; Package management setup
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("gnu" . "https://elpa.gnu.org/packages/")
                         ("nongnu" . "https://elpa.nongnu.org/nongnu/")))
(package-initialize)

;; Refresh package contents if not already available
(unless package-archive-contents
  (package-refresh-contents))

;; Install use-package if not already installed
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

;; Install and config company mode
(use-package company
  :hook (after-init . global-company-mode)
  :config
  (setq company-idle-delay 0.1      ;;thinking delay
        company-minimum-prefix-length 2
        company-selection-wrap-around t))

;; Install and configure doom themes
(use-package doom-themes
  :config
  (load-theme 'doom-acario-dark t)) ;;sets theme to doom-acario-dark

;; Set up JetBrains Mono Nerd font
(set-face-attribute 'default nil
                    :family "JetBrainsMono Nerd Font"
                    :height 110) ;; Text Size

;; Enable line numbers, but only for buffers editing files, and not for the file todo.org
(defun enable-line-numbers ()
  "Enable line numbers for non-todo.org files and non-special buffers."
  (unless (or (not (buffer-file-name))            ; Not a file buffer
              (string= (buffer-name) "todo.org")   ; The specific todo.org file
              (derived-mode-p 'eshell-mode)       ; In eshell
              (derived-mode-p 'eww-mode))        ; In eww (browser)
    (display-line-numbers-mode 1)))                ; Enable line numbers

(add-hook 'find-file-hook 'enable-line-numbers)    ; Apply to opening files
(add-hook 'after-save-hook 'enable-line-numbers)    ; Apply after saving files
(add-hook 'eshell-mode-hook (lambda () (display-line-numbers-mode -1))) ; Disable in eshell
(add-hook 'eww-mode-hook (lambda () (display-line-numbers-mode -1)))    ; Disable in eww


;; Enable syntax highlighting
(global-font-lock-mode t)

;; Improve minibuffer completion
(setq completion-ignore-case t
      read-buffer-completion-ignore-case t
      read-line-name-completion-ignore-case t)

;; Reload emacs on the spot
(defun reload-emacs-config ()
  "Reload Init.el"
  (interactive)
  (save-some-buffers t)
  (load-file "~/.emacs.d/init.el"))

(global-set-key (kbd "C-c r") 'reload-emacs-config)

(add-hook 'emacs-startup-hook
          (lambda ()
            (split-window-right 110)
            (other-window 1)
            (find-file "~/todo.org")
            (other-window 1)
            (find-file "~/.emacs.d/init.el")
	    (split-window-below 20)
	    (other-window 1)
	    (eshell)))

(setq inhibit-startup-screen t)

(global-set-key (kbd "C-c w") 'eww)
