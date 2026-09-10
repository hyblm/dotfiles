;;; early-init.el -*- lexical-binding: t; -*-

;; Let straight.el manage package activation instead of package.el at startup.
(setq package-enable-at-startup nil)

(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

(set-face-attribute 'default nil :background "#100F0F" :foreground "#B4BDC3")
(advice-add #'x-apply-session-resources :override #'ignore)

(defvar file-name-handler-alist-old file-name-handler-alist)
(setq file-name-handler-alist nil)
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq file-name-handler-alist file-name-handler-alist-old)))

