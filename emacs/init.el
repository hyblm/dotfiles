(load-theme 'tao-yin t)

(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(pixel-scroll-precision-mode 1)
(global-auto-revert-mode 1)
(recentf-mode 1)
(setq history-length 25)
(savehist-mode 1)
(save-place-mode 1)

(setq scroll-conservatively 101
      scroll-margin 5)
(setq inhibit-startup-message t
      use-dialog-box nil
      visible-bell t)

(setq custom-file (locate-user-emacs-file "custom-vars.el"))
(load custom-file 'noerror 'nomessage)
(setq backup-directory-alist         `(("." . ,(expand-file-name "backups/" user-emacs-directory)))
      auto-save-file-name-transforms `((".*" ,(expand-file-name "auto-saves/" user-emacs-directory) t)))

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'default-frame-alist '((undecorated . t)))
(add-to-list 'default-frame-alist '(font . "Lilex Nerd Font-10"))

(add-hook 'dired-mode-hook 'dired-hide-details-mode)
(vertico-mode 1)
(marginalia-mode 1)
(require 'orderless)
(setq completion-styles '(orderless basic)
      completion-category-overrides '((file (styles partial-completion)))
      completion-pcm-leading-wildcard t) ;; Emacs 31: partial-completion behaves like substring

(require 'package)
(package-initialize)
(add-to-list 'load-path (expand-file-name "config" user-emacs-directory))

(require 'meow-config)

(setq display-time-default-load-average nil)
(display-time-mode 1)
(display-battery-mode 1)
(icomplete-vertical-mode 1)
(server-start)
(require 'exwm-config)
