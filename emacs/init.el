;;; -*- lexical-binding: t; -*-

;; Bootstrap straight.el before declaring packages.
(let* ((straight-base (expand-file-name "straight/" user-emacs-directory))
       (straight-dir (expand-file-name "repos/straight.el" straight-base))
       (bootstrap-file (expand-file-name "bootstrap.el" straight-dir)))
  (unless (file-exists-p bootstrap-file)
    (make-directory straight-base t)
    (call-process "git" nil "*straight-bootstrap*" nil "clone"
                  "https://github.com/radian-software/straight.el.git"
                  straight-dir))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)
(setq straight-use-package-by-default t)
(eval-when-compile (require 'use-package))

(use-package tao-theme
  :config
  (defun my/system-dark-mode-p ()
    "Return non-nil when the desktop is currently using a dark theme."
    (when (executable-find "gsettings")
      (let ((color-scheme
             (string-trim
              (shell-command-to-string
               "gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null")))
            (gtk-theme
             (string-trim
              (shell-command-to-string
               "gsettings get org.gnome.desktop.interface gtk-theme 2>/dev/null"))))
        (or (string-match-p "dark" color-scheme)
            (string-match-p "dark" gtk-theme)))))

  (defun my/sync-theme-with-system ()
    "Select the Tao theme matching the desktop appearance."
    (let ((theme (if (my/system-dark-mode-p) 'tao-yin 'tao-yang)))
      (unless (custom-theme-enabled-p theme)
        (mapc #'disable-theme custom-enabled-themes)
        (load-theme theme t))))

  ;; Select the theme once when Emacs starts.  Emacs has no portable hook for
  ;; desktop appearance changes; reacting while running is desktop-specific.
  (my/sync-theme-with-system))

(use-package pi-coding-agent
  :config (defalias 'pi 'pi-coding-agent))
(use-package magit)
(use-package vterm)
(use-package eat)
(use-package vertico
  :init (vertico-mode 1))
(use-package marginalia
  :init (marginalia-mode 1))
(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-pcm-leading-wildcard t))

(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(pixel-scroll-precision-mode 1)
(global-auto-revert-mode 1)
(recentf-mode 1)
(setq history-length 25)
(savehist-mode 1)
(save-place-mode 1)

(setq scroll-conservatively 101 scroll-margin 5
      inhibit-startup-message t use-dialog-box nil visible-bell t)
(setq custom-file (locate-user-emacs-file "custom-vars.el"))
(load custom-file 'noerror 'nomessage)
(setq backup-directory-alist
      `(("." . ,(expand-file-name "backups/" user-emacs-directory)))
      auto-save-file-name-transforms
      `((".*" ,(expand-file-name "auto-saves/" user-emacs-directory) t)))

(add-to-list 'default-frame-alist '(undecorated . t))
(add-to-list 'default-frame-alist '(font . "Lilex Nerd Font-10"))
(add-hook 'dired-mode-hook #'dired-hide-details-mode)
(add-to-list 'load-path (expand-file-name "config" user-emacs-directory))

(use-package meow
  :config (require 'meow-config))

(setq display-time-default-load-average nil)
(display-time-mode 1)
(display-battery-mode 1)
(icomplete-vertical-mode 1)
(server-start)

