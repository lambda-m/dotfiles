;;; --- START SMART HEADER ---

;; 1. Force state/junk to a local directory (not symlinked via Stow)
(setq user-emacs-directory (expand-file-name "~/.local/state/emacs/"))
(unless (file-exists-p user-emacs-directory)
  (make-directory user-emacs-directory t))

;; 2. Move the customization file (where Emacs writes UI changes) to state
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

;;; --- END SMART HEADER ---

;; Initialize package sources
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Initialize use-package
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; Initialize no-littering to keep remaining plugins in check
(use-package no-littering
  :demand t)

;; Redirect auto-saves to the state directory
(setq auto-save-file-name-transforms
      `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))

(use-package auto-package-update
  :custom
  (auto-package-update-interval 7)
  (auto-package-update-prompt-before-update t)
  (auto-package-update-hide-results t)
  :config
  (auto-package-update-maybe)
  (auto-package-update-at-time "09:00"))

;; Nord theme
(use-package nord-theme
  :config
  (load-theme 'nord t))

;; All the icons
(use-package all-the-icons
  :if (display-graphic-p))

;; Neotree
(use-package neotree)
(global-set-key [f8] 'neotree-toggle)
(setq neo-smart-open t)
(setq neo-window-fixed-size nil)

(setq inhibit-startup-message t)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 10)
(menu-bar-mode -1)
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

;; Keybindings
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
(global-set-key "[" 'insert-parentheses)
(global-set-key "]" 'move-past-close-and-reindent)

(require 'windmove)
(global-set-key (kbd "M-<up>") 'windmove-up)
(global-set-key (kbd "M-<left>") 'windmove-left)
(global-set-key (kbd "M-<right>") 'windmove-right)
(global-set-key (kbd "M-<down>") 'windmove-down)

;; Yaml to JSON
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
                (insert converted-content))))
        (message "Conversion failed.")))))

(global-set-key (kbd "C-c y") 'yaml-to-json)
(global-set-key (kbd "C-c j") 'json-to-yaml)
