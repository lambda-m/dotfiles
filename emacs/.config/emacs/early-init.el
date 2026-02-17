;;; early-init.el --- Pre-initialization settings -*- lexical-binding: t -*-

;; 1. Prevent the eln-cache from cluttering the dotfiles folder
(when (boundp 'native-comp-eln-load-path)
  (let ((eln-cache-dir (expand-file-name "var/eln-cache/" (expand-file-name "~/.local/state/emacs/"))))
    ;; Create the directory so Emacs doesn't fail
    (unless (file-exists-p eln-cache-dir)
      (make-directory eln-cache-dir t))
    ;; Redirect the cache
    (setcar native-comp-eln-load-path eln-cache-dir)))

;; 2. Optional: Speed up startup by delaying garbage collection
(setq gc-cons-threshold most-positive-fixnum)
