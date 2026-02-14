
;; Initialize package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(use-package auto-package-update
  :custom
  (auto-package-update-interval 7)
  (auto-package-update-prompt-before-update t)
  (auto-package-update-hide-results t)
  :config
  (auto-package-update-maybe)
  (auto-package-update-at-time "09:00"))

;; Set theme
(use-package monokai-theme)
(load-theme 'monokai t)

;; All the icons
(use-package all-the-icons
  :if (display-graphic-p))

;; Neotree for monkeys like me
(use-package neotree)
(global-set-key [f8] 'neotree-toggle)
(setq neo-smart-open t)
(setq neo-window-fixed-size nil)

;; NOTE: If you want to move everything out of the ~/.emacs.d folder
;; reliably, set `user-emacs-directory` before loading no-littering!
;(setq user-emacs-directory "~/.cache/emacs")

(use-package no-littering)

;; no-littering doesn't set this by default so we must place
;; auto save files in the same path as it uses for sessions
(setq auto-save-file-name-transforms
      `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))

(setq inhibit-startup-message t)

(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 10)        ; Give some breathing room

(menu-bar-mode -1)            ; Disable the menu bar

;; Set up the visible bell
(setq visible-bell t)

(column-number-mode)
(global-display-line-numbers-mode t)

;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                treemacs-mode-hook
                eshell-mode-hook
		neotree-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; Parentheses... parentheses everywhere
(global-set-key "[" 'insert-parentheses)
(global-set-key "]" 'move-past-close-and-reindent)

;; Use Meta with arrow keys to navigate windows
(require 'windmove)
(global-set-key (kbd "M-<up>") 'windmove-up)
(global-set-key (kbd "M-<left>") 'windmove-left)
(global-set-key (kbd "M-<right>") 'windmove-right)
(global-set-key (kbd "M-<down>") 'windmove-down)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(neotree all-the-icons monokai-theme no-littering auto-package-update)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Yaml to JSON shizzle
(defun yaml-to-json ()
  (interactive)
  (let* ((original-buffer (current-buffer))
         (original-content (buffer-string))
         (conversion-command "yq eval -o=json"))
    (with-temp-buffer
      (insert original-content)
      (if (zerop (shell-command-on-region (point-min) (point-max) conversion-command nil t))
          (progn
            (let ((converted-content (buffer-string)))
              (with-current-buffer original-buffer
                (erase-buffer)
                (insert converted-content))))
        (message "Conversion failed.")))))

;; Adjust `json-to-yaml` similarly

(defun json-to-yaml ()
  (interactive)
  (let* ((original-buffer (current-buffer))
         (original-content (buffer-string))
         (conversion-command "yq eval --output-format=yaml"))
    (with-temp-buffer
      (insert original-content)
      (if (zerop (shell-command-on-region (point-min) (point-max) conversion-command nil t))
          (progn
            (let ((converted-content (buffer-string)))
              (with-current-buffer original-buffer
                ;;(erase-buffer)
                (insert converted-content))))
        (message "Conversion failed.")))))

(global-set-key (kbd "C-c y") 'yaml-to-json)
(global-set-key (kbd "C-c j") 'json-to-yaml)
