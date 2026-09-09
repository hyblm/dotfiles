;;; init.el -*- lexical-binding: t; -*-

(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file :no-error-if-file-is-missing)


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


(add-to-list 'display-buffer-alist
             '("\\`\\*\\(Warnings\\|Compile-Log\\)\\*\\'"
               (display-buffer-no-window)
	       (allow-no-window . t)))



(use-package delsel
  :ensure nil
  :straight (:type built-in)
  :hook (after-init . delete-selection-mode))

(defun prot/keyboard-quit-dwim ()
  "Do-What-I-Mean behaviour for a general `keyboard-quit'.

The generic `keyboard-quit' does not do the expected thing when
the minibuffer is open.  Whereas we want it to close the
minibuffer, even without explicitly focusing it.

The DWIM behaviour of this command is as follows:

- When the region is active, disable it.
- When a minibuffer is open, but not focused, close the minibuffer.
- When the Completions buffer is selected, close it.
- In every other case use the regular `keyboard-quit'."
  (interactive)
  (cond
   ((region-active-p)
    (keyboard-quit))
   ((derived-mode-p 'completion-list-mode)
    (delete-completion-window))
   ((> (minibuffer-depth) 0)
    (abort-recursive-edit))
   (t
    (keyboard-quit))))

(define-key global-map (kbd "C-g") #'prot/keyboard-quit-dwim)


(set-face-attribute 'default        nil :font "Lilex Nerd Font"            :weight 'normal :height 110)
(set-face-attribute 'fixed-pitch    nil :font "Lilex Nerd Font"            :weight 'normal :height 1.0)
(set-face-attribute 'variable-pitch nil :font "Atkinson Hyperlegible Next" :weight 'normal :height 1.2)

(use-package ligature
  :config
  ;; Enable the "www" ligature in every possible major mode
  (ligature-set-ligatures 't '("www"))
  ;; Enable traditional ligature support in eww-mode, if the
  ;; `variable-pitch' face supports it
  (ligature-set-ligatures 'eww-mode '("ff" "fi" "ffi"))
  ;; Enable all Cascadia Code ligatures in programming modes
  (ligature-set-ligatures 'prog-mode '("|||>" "<|||" "<==>" "<!--" "####" "~~>" "***" "||=" "||>"
                                       ":::" "::=" "=:=" "===" "==>" "=!=" "=>>" "=<<" "=/=" "!=="
                                       "!!." ">=>" ">>=" ">>>" ">>-" ">->" "->>" "-->" "---" "-<<"
                                       "<~~" "<~>" "<*>" "<||" "<|>" "<$>" "<==" "<=>" "<=<" "<->"
                                       "<--" "<-<" "<<=" "<<-" "<<<" "<+>" "</>" "###" "#_(" "..<"
                                       "..." "+++" "/==" "///" "_|_" "www" "&&" "^=" "~~" "~@" "~="
                                       "~>" "~-" "**" "*>" "*/" "||" "|}" "|]" "|=" "|>" "|-" "{|"
                                       "[|" "]#" "::" ":=" ":>" ":<" "$>" "==" "=>" "!=" "!!" ">:"
                                       ">=" ">>" ">-" "-~" "-|" "->" "--" "-<" "<~" "<*" "<|" "<:"
                                       "<$" "<=" "<>" "<-" "<<" "<+" "</" "#{" "#[" "#:" "#=" "#!"
                                       "##" "#(" "#?" "#_" "%%" ".=" ".-" ".." ".?" "+>" "++" "?:"
                                       "?=" "?." "??" ";;" "/*" "/=" "/>" "//" "__" "~~" "(*" "*)"
                                       "\\\\" "://"))
  ;; Enables ligature checks globally in all buffers. You can also do it
  ;; per mode with `ligature-mode'.
  (global-ligature-mode t))



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
  "Select the configured theme matching the desktop appearance."
  (let ((theme (if (my/system-dark-mode-p) 'zenbones-dark 'zenbones-light)))
    (unless (custom-theme-enabled-p theme)
      (mapc #'disable-theme custom-enabled-themes)
      (load-theme theme t))))

;;;; Make local themes and their shared definitions discoverable.
(let ((theme-dir (expand-file-name "themes" user-emacs-directory)))
  (add-to-list 'custom-theme-load-path theme-dir)
  (add-to-list 'load-path theme-dir))

(my/sync-theme-with-system)

  ;;;; Nerd Icons
(use-package nerd-icons
  :ensure t)
(use-package nerd-icons-completion
  :ensure t
  :after marginalia
  :config
  (nerd-icons-completion-mode)
  (add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup))
(use-package nerd-icons-corfu
  :ensure t
  :after corfu
  :config
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))
(use-package nerd-icons-dired
  :ensure t
  :hook
  (dired-mode . nerd-icons-dired-mode))

  ;;; Minibuffer improvements
(use-package vertico
  :ensure t
  :custom
  (vertico-cycle t) ;; Enable cycling for `vertico-next/previous'
  :hook
  (after-init . vertico-mode))

(use-package marginalia
  :ensure t
  ;; Bind `marginalia-cycle' locally in the minibuffer.  To make the binding
  ;; available in the *Completions* buffer, add it to the
  ;; `completion-list-mode-map'.
  :bind
  (:map minibuffer-local-map
        ("M-A" . marginalia-cycle))
  :hook
  (after-init . marginalia-mode))

;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :ensure nil
  :hook (after-init . savehist-mode))

(use-package orderless
  :ensure t
  :config
  (setq completion-styles '(orderless basic))
  (setq completion-category-defaults nil)
  (setq completion-category-overrides nil)
  (setq completion-pcm-leading-wildcard nil)) ;; Emacs 31: partial-completion behaves like substring

  ;;; Completion
(use-package corfu
  :ensure t
  :hook (after-init . global-corfu-mode)
  :bind (:map corfu-map ("<tab>" . corfu-complete))
  :custom
  (tab-always-indent 'complete)
  (corfu-preview-current nil)
  (corfu-min-width 20)

  (corfu-popupinfo-delay '(1.25 . 0.5))
  (corfu-popupinfo-mode 1) ; shows documentation after `corfu-popupinfo-delay'

  :config
  ;; Sort by input history (no need to modify `corfu-sort-function').
  (with-eval-after-load 'savehist
    (corfu-history-mode 1)
    (add-to-list 'savehist-additional-variables 'corfu-history)))

(use-package goggles
  :hook ((prog-mode text-mode) . goggles-mode)
  :config
  (setq-default goggles-pulse t)) ;; set to nil to disable pulsing

;;; Dired
(use-package dired
  :ensure nil
  :straight (:type built-in)
  :commands (dired)
  :hook
  ((dired-mode . dired-hide-details-mode)
   (dired-mode . hl-line-mode))
  :custom
  (dired-recursive-copies  'always)
  (dired-recursive-deletes 'always)
  (delete-by-moving-to-trash t)
  (dired-dwim-target t))

(use-package dired-subtree
  :ensure t
  :after dired
  :bind
  ( :map dired-mode-map
    ("<tab>"     . dired-subtree-toggle)
    ("TAB"       . dired-subtree-toggle)
    ("<backtab>" . dired-subtree-remove)
    ("S-TAB"     . dired-subtree-remove))
  :custom
  (dired-subtree-use-backgrounds nil))

(use-package trashed
  :ensure t
  :commands (trashed)
  :custom
  (trashed-action-confirmer 'y-or-n-p)
  (trashed-use-header-line t)
  (trashed-sort-key '("Date deleted" . t))
  (trashed-date-format "%Y-%m-%d %H:%M:%S"))

(setq backup-directory-alist
      `(("." . ,(expand-file-name "backups/" user-emacs-directory)))
      auto-save-file-name-transforms
      `((".*" ,(expand-file-name "auto-saves/" user-emacs-directory) t)))

(add-to-list 'default-frame-alist '(undecorated . t))
(add-hook 'dired-mode-hook #'dired-hide-details-mode)
(add-to-list 'load-path (expand-file-name "config" user-emacs-directory))
(require 'system-menus)

(setq scroll-conservatively 101
      scroll-margin 5
      inhibit-startup-message t
      use-dialog-box nil
      visible-bell t
      display-time-default-load-average nil)

(display-time-mode 1)
(display-battery-mode 1)
;; This setting is suggested by the exwm docs but doesn't seem to play nice with vertico
;; (icomplete-vertical-mode 1)
(pixel-scroll-precision-mode 1)
(global-auto-revert-mode 1)
(recentf-mode 1)
(setq history-length 25)
(save-place-mode 1)

(use-package magit)
(use-package eat)
(use-package vterm)
(use-package vundo)

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
(use-package embark-consult) ; only need to install it, embark loads it after consult if found

(use-package doom-modeline
  :init (doom-modeline-mode 1))

(use-package org-modern
  :hook
  (org-mode . org-modern-mode)
  (org-agenda-finalize . org-modern-agenda)
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
  :hook
  (text-mode . mixed-pitch-mode))

(use-package olivetti
  :custom
  (olivetti-minimum-body-width 80)
  (olivetti-recall-visual-line-mode-entry-state t)
  :config
  (setq-default olivetti-body-width 0.7)
  :hook ((text-mode . olivetti-mode)))


(use-package meow
  :config (require 'meow-config))

(use-package pi-coding-agent
  :config (defalias 'pi 'pi-coding-agent))

;; Keep EXWM installed, but only start it from the EXWM desktop session.
(use-package exwm
  :config
  ;; Desktop Entry starts Emacs with EXWM_SESSION=1.  Loading this from init.el
  ;; is reliable because command-line --load actions run only after init.el.
  (when (equal (getenv "EXWM_SESSION") "1")
    (require 'exwm-config)))

(use-package exwm-modeline
  :after (exwm)
  :config
  (setq exwm-modeline-short t)
  (add-hook 'exwm-init-hook #'exwm-modeline-mode))

(use-package xdg-launcher
  :after (exwm)
  :straight '(xdg-launcher :host github :repo "emacs-exwm/xdg-launcher"))

(server-start)
