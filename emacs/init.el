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
(require 'bluetooth)
(require 'system-menus)

(setq scroll-conservatively 101
      scroll-margin 5
      inhibit-startup-message t
      use-dialog-box nil
      visible-bell nil
      display-time-default-load-average nil)

(display-time-mode 1)
(display-battery-mode 1)
;; This setting is suggested by the exwm docs but doesn't seem to play nice with vertico
;; (icomplete-vertical-mode 1)
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(pixel-scroll-precision-mode 1)
(global-auto-revert-mode 1)
(recentf-mode 1)
(setq history-length 25)
(savehist-mode 1)
(save-place-mode 1)

(use-package naysayer-theme)
(use-package doom-themes
  :ensure t)
(use-package tao-theme)

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
  "Select the Tao theme matching the desktop appearance."
  (let ((theme (if (my/system-dark-mode-p) 'doom-tomorrow-night 'doom-tomorrow-day)))
    (unless (custom-theme-enabled-p theme)
      (mapc #'disable-theme custom-enabled-themes)
      (load-theme theme t))))

(my/sync-theme-with-system)

(use-package magit)
(use-package eat)
(use-package vterm)

;; Enable Vertico.
(use-package vertico
  :custom
  ;; (vertico-scroll-margin 0) ;; Different scroll margin
  ;; (vertico-count 20) ;; Show more candidates
  ;; (vertico-resize t) ;; Grow and shrink the Vertico minibuffer
     (vertico-cycle t) ;; Enable cycling for `vertico-next/previous'
  :init
  (vertico-mode))

;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :init
  (savehist-mode))

;; Emacs minibuffer configurations.
(use-package emacs
  :custom
  ;; Enable context menu. `vertico-multiform-mode' adds a menu in the minibuffer
  ;; to switch display modes.
  (context-menu-mode t)
  ;; Support opening new minibuffers from inside existing minibuffers.
  (enable-recursive-minibuffers t)
  ;; Hide commands in M-x which do not work in the current mode.  Vertico
  ;; commands are hidden in normal buffers. This setting is useful beyond
  ;; Vertico.
  (read-extended-command-predicate #'command-completion-default-include-p)
  ;; Do not allow the cursor in the minibuffer prompt
  (minibuffer-prompt-properties
   '(read-only t cursor-intangible t face minibuffer-prompt)))

;; Enable rich annotations using the Marginalia package
(use-package marginalia
  ;; Bind `marginalia-cycle' locally in the minibuffer.  To make the binding
  ;; available in the *Completions* buffer, add it to the
  ;; `completion-list-mode-map'.
  :bind (:map minibuffer-local-map
         ("M-A" . marginalia-cycle))

  ;; The :init section is always executed.
  :init

  ;; Marginalia must be activated in the :init section of use-package such that
  ;; the mode gets enabled right away. Note that this forces loading the
  ;; package.
  (marginalia-mode))

(use-package orderless
  :custom
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (orderless-style-dispatchers '(+orderless-consult-dispatch orderless-affix-dispatch))
  ;; (orderless-component-separator #'orderless-escapable-split-on-space)
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-category-defaults nil) ;; Disable defaults, use our settings
  (completion-pcm-leading-wildcard t)) ;; Emacs 31: partial-completion behaves like substring


;; Example configuration for Consult
(use-package consult
  ;; Replace bindings. Lazily loaded by `use-package'.
  :bind (;; C-c bindings in `mode-specific-map'
         ("C-c M-x" . consult-mode-command)
         ("C-c h" . consult-history)
         ("C-c k" . consult-kmacro)
         ("C-c m" . consult-man)
         ("C-c i" . consult-info)
         ([remap Info-search] . consult-info)
         ;; C-x bindings in `ctl-x-map'
         ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
         ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
         ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
         ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
         ("C-x t b" . consult-buffer-other-tab)    ;; orig. switch-to-buffer-other-tab
         ("C-x r b" . consult-bookmark)            ;; orig. bookmark-jump
         ("C-x p b" . consult-project-buffer)      ;; orig. project-switch-to-buffer
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)                ;; orig. yank-pop
         ;; M-g bindings in `goto-map'
         ("M-g e" . consult-compile-error)
         ("M-g r" . consult-grep-match)
         ("M-g f" . consult-flymake)               ;; Alternative: consult-flycheck
         ("M-g g" . consult-goto-line)             ;; orig. goto-line
         ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
         ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings in `search-map'
         ("M-s d" . consult-fd)                  ;; Alternative: consult-fd
         ("M-s c" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
         ("M-s e" . consult-isearch-history)       ;; orig. isearch-edit-string
         ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
         ("M-s L" . consult-line-multi)            ;; needed by consult-line to detect isearch
         ;; Minibuffer history
         :map minibuffer-local-map
         ("M-s" . consult-history)                 ;; orig. next-matching-history-element
         ("M-r" . consult-history))                ;; orig. previous-matching-history-element

  ;; The :init configuration is always executed (Not lazy)
  :init

  ;; Tweak the register preview for `consult-register-load',
  ;; `consult-register-store' and the built-in commands.  This improves the
  ;; register formatting, adds thin separator lines, register sorting and hides
  ;; the window mode line.
  (advice-add #'register-preview :override #'consult-register-window)
  (setq register-preview-delay 0.5)

  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  ;; Configure other variables and modes in the :config section,
  ;; after lazily loading the package.
  :config

  ;; Optionally configure preview. The default value
  ;; is 'any, such that any key triggers the preview.
  ;; (setq consult-preview-key 'any)
  ;; (setq consult-preview-key "M-.")
  ;; (setq consult-preview-key '("S-<down>" "S-<up>"))
  ;; For some commands and buffer sources it is useful to configure the
  ;; :preview-key on a per-command basis using the `consult-customize' macro.
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep consult-man
   consult-bookmark consult-recent-file consult-xref
   consult-source-bookmark consult-source-file-register
   consult-source-recent-file consult-source-project-recent-file
   ;; :preview-key "M-."
   :preview-key '(:debounce 0.4 any))

  ;; Optionally configure the narrowing key.
  ;; Both < and C-+ work reasonably well.
  (setq consult-narrow-key "<") ;; "C-+"

  ;; Optionally make narrowing help available in the minibuffer.
  ;; You may want to use `embark-prefix-help-command' or which-key instead.
  ;; (keymap-set consult-narrow-map (concat consult-narrow-key " ?") #'consult-narrow-help)
  )

(use-package embark
  :ensure t

  :bind
  (("C-." . embark-act)         ;; pick some comfortable binding
   ("C-;" . embark-dwim)        ;; good alternative: M-.
   ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'

  :init

  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)

  ;; Show the Embark target at point via Eldoc. You may adjust the
  ;; Eldoc strategy, if you want to see the documentation from
  ;; multiple providers. Beware that using this can be a little
  ;; jarring since the message shown in the minibuffer can be more
  ;; than one line, causing the modeline to move up and down:

  ;; (add-hook 'eldoc-documentation-functions #'embark-eldoc-first-target)
  ;; (setq eldoc-documentation-strategy #'eldoc-documentation-compose-eagerly)

  ;; Add Embark to the mouse context menu. Also enable `context-menu-mode'.
  ;; (context-menu-mode 1)
  ;; (add-hook 'context-menu-functions #'embark-context-menu 100)

  :config

  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

;; Consult users will also want the embark-consult package.
(use-package embark-consult
  :ensure t) ; only need to install it, embark loads it after consult if found

;; I'm activating mini-modeline after smart-mode-line
(use-package mini-modeline
  ;; :after smart-mode-line
  :config
  (setq mini-modeline-display-gui-line nil)
  (mini-modeline-mode t))
;; (use-package nerd-icons
;;   :ensure t
;;   :custom
;;   (nerd-icons-font-family "Lilex Nerd Font Mono"))
;; (use-package doom-modeline
;;   :ensure t
;;   :init (doom-modeline-mode 1))

(use-package markdown-mode
  :ensure t
  :mode ("README\\.md\\'" . gfm-mode)
  :init (setq markdown-command "multimarkdown")
  :bind (:map markdown-mode-map
              ("C-c C-e" . markdown-do)))
(use-package mixed-pitch
  :hook
  ;; If you want it in all text modes:
  (text-mode . mixed-pitch-mode))
(set-face-attribute 'default nil :font "Lilex Nerd Font Mono" :weight 'normal :height 100)
(set-face-attribute 'fixed-pitch nil :font "Lilex Nerd Font Mono" :weight 'normal :height 100)
(set-face-attribute 'variable-pitch nil :font "Adwaita Sans" :weight 'normal :height 1.3)

(use-package olivetti)
(use-package mixed-pitch
  :hook
  ;; If you want it in all text modes:
  (text-mode . mixed-pitch-mode))

(use-package meow
  :config (require 'meow-config))

(use-package pi-coding-agent
 :config (defalias 'pi 'pi-coding-agent))

;; Keep EXWM installed, but only start it from the EXWM desktop session.
(use-package exwm
  :defer t)

;; Desktop Entry starts Emacs with EXWM_SESSION=1.  Loading this from init.el
;; is reliable because command-line --load actions run only after init.el.
(when (equal (getenv "EXWM_SESSION") "1")
  (require 'exwm-config))

(server-start)
