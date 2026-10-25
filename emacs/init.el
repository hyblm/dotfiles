;;; init.el -*- lexical-binding: t; -*-

(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file :no-error-if-file-missing)

;; Elpaca bootstrap (see https://github.com/progfolio/elpaca).
(defvar elpaca-installer-version 0.12)
(defvar elpaca-directory (expand-file-name "elpaca/" user-emacs-directory))
(defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
(defvar elpaca-sources-directory (expand-file-name "sources/" elpaca-directory))
(defvar elpaca-order
  '(elpaca :repo "https://github.com/progfolio/elpaca.git"
           :ref nil :depth 1 :inherit ignore
           :files (:defaults "elpaca-test.el" (:exclude "extensions"))
           :build (:not elpaca-activate)))
(let* ((repo (expand-file-name "elpaca/" elpaca-sources-directory))
       (build (expand-file-name "elpaca/" elpaca-builds-directory))
       (order (cdr elpaca-order))
       (default-directory repo))
  (add-to-list 'load-path (if (file-exists-p build) build repo))
  (unless (file-exists-p repo)
    (make-directory repo t)
    (when (<= emacs-major-version 28) (require 'subr-x))
    (condition-case err
        (if-let* ((buffer (get-buffer-create "*elpaca-bootstrap*"))
                  ((zerop (apply #'call-process
                                 `("git" nil ,buffer t "clone"
                                   ,@(when-let* ((depth (plist-get order :depth)))
                                       (list (format "--depth=%d" depth) "--no-single-branch"))
                                   ,(plist-get order :repo) ,repo))))
                  ((zerop (call-process "git" nil buffer t "checkout"
                                        (or (plist-get order :ref) "--"))))
                  (emacs (expand-file-name invocation-name invocation-directory))
                  ((zerop (call-process emacs nil buffer nil "-Q" "-L" "."
                                        "--batch" "--eval"
                                        "(byte-recompile-directory \".\" 0 'force)")))
                  ((require 'elpaca))
                  ((elpaca-generate-autoloads "elpaca" repo)))
            (progn (message "%s" (with-current-buffer buffer (buffer-string)))
                   (kill-buffer buffer))
          (error "Elpaca bootstrap failed: %s"
                 (with-current-buffer buffer (buffer-string))))
      (error (warn "%s" err) (delete-directory repo 'recursive))))
  (unless (require 'elpaca-autoloads nil t)
    (require 'elpaca)
    (elpaca-generate-autoloads "elpaca" repo)
    (let ((load-source-file-function nil)) (load "./elpaca-autoloads"))))
(add-hook 'after-init-hook #'elpaca-process-queues)
(elpaca `(,@elpaca-order))

(elpaca elpaca-use-package
  (elpaca-use-package-mode))
(setq use-package-always-ensure t)
(eval-when-compile (require 'use-package))

(add-to-list 'display-buffer-alist
             '("\\`\\*\\(Warnings\\|Compile-Log\\)\\*\\'"
               (display-buffer-no-window)
               (allow-no-window . t)))

(setq backup-directory-alist
      `(("." . ,(expand-file-name "backups/" user-emacs-directory)))
      auto-save-file-name-transforms
      `((".*" ,(expand-file-name "auto-saves/" user-emacs-directory) t))
      scroll-conservatively 101
      scroll-margin 5
      inhibit-startup-message t
      use-dialog-box nil
      visible-bell t
      display-time-default-load-average nil
      history-length 25
      enable-recursive-minibuffers t
      minibuffer-prompt-properties
      '(read-only t cursor-intangible t face minibuffer-prompt)
      read-extended-command-predicate #'command-completion-default-include-p)

(add-to-list 'default-frame-alist '(undecorated . t))
(add-to-list 'load-path (expand-file-name "config" user-emacs-directory))
(require 'system-menus)
(display-time-mode 1)
(display-battery-mode 1)
(pixel-scroll-precision-mode 1)
(global-auto-revert-mode 1)
(setq recentf-max-saved-items 100)
(add-hook 'after-init-hook #'recentf-mode)
(save-place-mode 1)
(server-start)

(use-package delsel
  :ensure nil
  :hook (after-init . delete-selection-mode))

(defun my/keyboard-quit-dwim ()
  "Quit the active context, including a recursive minibuffer."
  (interactive)
  (cond
   ((region-active-p) (keyboard-quit))
   ((derived-mode-p 'completion-list-mode) (delete-completion-window))
   ((> (minibuffer-depth) 0) (abort-recursive-edit))
   (t (keyboard-quit))))
(keymap-global-set "C-g" #'my/keyboard-quit-dwim)

(use-package emacs
  :ensure nil
  :custom
  (context-menu-mode t))

(set-face-attribute 'default nil :font "Lilex Nerd Font" :weight 'normal :height 110)
(set-face-attribute 'fixed-pitch nil :font "Lilex Nerd Font" :weight 'normal :height 1.0)
(set-face-attribute 'variable-pitch nil :font "Atkinson Hyperlegible Next" :weight 'normal :height 1.2)

(defun my/system-dark-mode-p ()
  "Return non-nil when the desktop is currently using a dark theme."
  (when (executable-find "gsettings")
    (let ((color-scheme
           (string-trim
            (shell-command-to-string "gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null")))
          (gtk-theme
           (string-trim
            (shell-command-to-string "gsettings get org.gnome.desktop.interface gtk-theme 2>/dev/null"))))
      (or (string-match-p "dark" color-scheme)
          (string-match-p "dark" gtk-theme)))))

(defun my/sync-theme-with-system ()
  "Load the local theme matching desktop appearance."
  (let ((theme (if (my/system-dark-mode-p) 'zenbones-dark 'zenbones-light)))
    (unless (custom-theme-enabled-p theme)
      (mapc #'disable-theme custom-enabled-themes)
      (load-theme theme t))))

(let ((theme-dir (expand-file-name "themes" user-emacs-directory)))
  (add-to-list 'custom-theme-load-path theme-dir)
  (add-to-list 'load-path theme-dir))
;; Avoid blocking startup on synchronous desktop settings queries.
(run-with-idle-timer 0.5 nil #'my/sync-theme-with-system)

(use-package doom-modeline
  :init (doom-modeline-mode 1))

;; Toggle the current buffer's modeline for distraction-free editing.
(use-package hide-mode-line
  :bind ("C-c z" . hide-mode-line-mode))

(use-package nerd-icons)

(use-package nerd-icons-dired
  :hook (dired-mode . nerd-icons-dired-mode))

(use-package vertico
  :custom (vertico-cycle t)
  :hook (after-init . vertico-mode))

(use-package marginalia
  :bind (:map minibuffer-local-map ("M-A" . marginalia-cycle))
  :hook (after-init . marginalia-mode))

(use-package savehist
  :ensure nil
  :hook (after-init . savehist-mode))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides nil)
  (completion-pcm-leading-wildcard nil))

(use-package nerd-icons-completion
  :after marginalia
  :config
  (nerd-icons-completion-mode)
  (add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup))

(use-package consult
  :bind
  (("C-c M-x" . consult-mode-command)
   ("C-c h" . consult-history)
   ("C-c k" . consult-kmacro)
   ("C-c m" . consult-man)
   ("C-c i" . consult-info)
   ([remap Info-search] . consult-info)
   ("C-x M-:" . consult-complex-command)
   ("C-x b" . consult-buffer)
   ("C-x 4 b" . consult-buffer-other-window)
   ("C-x 5 b" . consult-buffer-other-frame)
   ("C-x t b" . consult-buffer-other-tab)
   ("C-x r b" . consult-bookmark)
   ("C-x p b" . consult-project-buffer)
   ("M-#" . consult-register-load)
   ("M-'" . consult-register-store)
   ("C-M-#" . consult-register)
   ("M-y" . consult-yank-pop)
   ("M-g e" . consult-compile-error)
   ("M-g r" . consult-grep-match)
   ("M-g f" . consult-flymake)
   ("M-g g" . consult-goto-line)
   ("M-g M-g" . consult-goto-line)
   ("M-g o" . consult-outline)
   ("M-g m" . consult-mark)
   ("M-g k" . consult-global-mark)
   ("M-g i" . consult-imenu)
   ("M-g I" . consult-imenu-multi)
   ("M-s d" . consult-fd)
   ("M-s c" . consult-locate)
   ("M-s g" . consult-grep)
   ("M-s G" . consult-git-grep)
   ("M-s r" . consult-ripgrep)
   ("M-s l" . consult-line)
   ("M-s L" . consult-line-multi)
   ("M-s k" . consult-keep-lines)
   ("M-s u" . consult-focus-lines)
   ("M-s e" . consult-isearch-history)
   :map isearch-mode-map
   ("M-e" . consult-isearch-history)
   ("M-s e" . consult-isearch-history)
   ("M-s l" . consult-line)
   ("M-s L" . consult-line-multi)
   :map minibuffer-local-map
   ("M-s" . consult-history)
   ("M-r" . consult-history))
  :init
  (advice-add #'register-preview :override #'consult-register-window)
  (setq register-preview-delay 0.5
        xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)
  :config
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep consult-man
   consult-bookmark consult-recent-file consult-xref
   consult-source-bookmark consult-source-file-register
   consult-source-recent-file consult-source-project-recent-file
   :preview-key '(:debounce 0.4 any))
  (setq consult-narrow-key "<"))

(use-package embark
  :bind (("C-." . embark-act)
         ("C-;" . embark-dwim)
         ("C-h B" . embark-bindings))
  :init (setq prefix-help-command #'embark-prefix-help-command)
  :config
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil (window-parameters (mode-line-format . none)))))

(use-package embark-consult)

(use-package corfu
  :hook (after-init . global-corfu-mode)
  :bind (:map corfu-map ("<tab>" . corfu-complete))
  :custom
  (tab-always-indent 'complete)
  (corfu-preview-current nil)
  (corfu-min-width 20)
  (corfu-popupinfo-delay '(1.25 . 0.5))
  :config
  (corfu-popupinfo-mode 1)
  (with-eval-after-load 'savehist
    (corfu-history-mode 1)
    (add-to-list 'savehist-additional-variables 'corfu-history)))

(use-package nerd-icons-corfu
  :after corfu
  :config (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

(use-package goggles
  :hook ((prog-mode text-mode) . goggles-mode)
  :custom (goggles-pulse t))

(add-to-list 'auto-mode-alist '("\\.mc\\'" . c-mode))

(use-package dired
  :ensure nil
  :ensure nil
  :commands (dired)
  :hook ((dired-mode . dired-hide-details-mode)
         (dired-mode . hl-line-mode))
  :custom
  (dired-recursive-copies 'always)
  (dired-recursive-deletes 'always)
  (delete-by-moving-to-trash t)
  (dired-dwim-target t))

(use-package dired-subtree
  :after dired
  :bind (:map dired-mode-map
              ("<tab>" . dired-subtree-toggle)
              ("TAB" . dired-subtree-toggle)
              ("<backtab>" . dired-subtree-remove)
              ("S-TAB" . dired-subtree-remove))
  :custom (dired-subtree-use-backgrounds nil))

(use-package trashed
  :commands (trashed)
  :custom
  (trashed-action-confirmer #'y-or-n-p)
  (trashed-use-header-line t)
  (trashed-sort-key '("Date deleted" . t))
  (trashed-date-format "%Y-%m-%d %H:%M:%S"))

(use-package magit)
(use-package eat)
(use-package vterm)
(use-package vundo)

(use-package org-modern
  :hook ((org-mode . org-modern-mode)
         (org-agenda-finalize . org-modern-agenda))
  :custom
  (org-modern-fold-stars '(("⏵ " . "⏷ ")))
  (org-auto-align-tags nil)
  (org-tags-column 0)
  (org-catch-invisible-edits 'show-and-error)
  (org-special-ctrl-a/e t)
  (org-insert-heading-respect-content t)
  (org-hide-emphasis-markers t)
  (org-pretty-entities t)
  (org-agenda-tags-column 0)
  (org-ellipsis " …"))

(use-package mixed-pitch
  :hook (text-mode . mixed-pitch-mode))

(use-package olivetti
  :custom
  (olivetti-minimum-body-width 80)
  (olivetti-recall-visual-line-mode-entry-state t)
  :config (setq-default olivetti-body-width 0.7)
  :hook (text-mode . olivetti-mode))

(use-package zig-mode
  :ensure t
  :mode "\\.zig\\'")

(add-to-list 'load-path (expand-file-name "config" user-emacs-directory))
(use-package meow
  :ensure t
  :demand t
  :config (require 'meow-config))

(add-to-list 'load-path (expand-file-name "config" user-emacs-directory))
(when (equal (getenv "EXWM_SESSION") "1")
  (elpaca exwm
    (require 'exwm)
    (require 'exwm-config))
  (elpaca-wait))

(use-package exwm-modeline
  :after exwm
  :config
  (setq exwm-modeline-short t)
  (add-hook 'exwm-init-hook #'exwm-modeline-mode))

(use-package xdg-launcher
  :after exwm
  :ensure (:host github :repo "emacs-exwm/xdg-launcher"))
