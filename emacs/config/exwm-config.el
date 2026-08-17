(require 'exwm)
(require 'exwm-randr)
;; Make Caps Lock act as Control for EXWM.
(call-process "setxkbmap" nil nil nil "-option" "ctrl:nocaps")
(setq exwm-workspace-number 4)

(defun exwm-sync-gtk-theme ()
  "Make GTK applications follow the current Tao theme."
  (when (executable-find "gsettings")
    (start-process
     "sync-gtk-theme" nil "gsettings" "set"
     "org.gnome.desktop.interface" "color-scheme"
     (if (memq 'tao-yin custom-enabled-themes)
         "prefer-dark"
       "prefer-light"))))

(defun exwm-toggle-tao-theme ()
  "Toggle between the Tao Yin and Tao Yang themes and update GTK."
  (interactive)
  (if (memq 'tao-yin custom-enabled-themes)
      (progn
        (disable-theme 'tao-yin)
        (load-theme 'tao-yang t))
    (disable-theme 'tao-yang)
    (load-theme 'tao-yin t))
  (exwm-sync-gtk-theme))

;; Synchronize GTK with the theme selected when EXWM starts.
(exwm-sync-gtk-theme)

(defun exwm-run-shell-command (command)
  "Run COMMAND asynchronously from an EXWM key binding."
  (interactive)
  (start-process-shell-command command nil command))

(defun exwm-switch-workspace-relative (offset)
  "Switch to the workspace OFFSET places from the current workspace."
  (interactive)
  (exwm-workspace-switch
   (mod (+ exwm-workspace-current-index offset) exwm-workspace-number)))

(setq exwm-input-global-keys
      `(
        ([?\s-r] . exwm-reset)
        (,(kbd "s-M-<print>") . exwm-toggle-tao-theme)
        ([?\s-w] . exwm-workspace-switch)
        ([?\s-p] . (lambda (cmd)
                     (interactive (list (read-shell-command "$ ")))
                     (start-process-shell-command cmd nil cmd)))
        ;; Workspace selection and navigation.
        ([?\s-1] . (lambda () (interactive) (exwm-workspace-switch 0)))
        ([?\s-2] . (lambda () (interactive) (exwm-workspace-switch 1)))
        ([?\s-3] . (lambda () (interactive) (exwm-workspace-switch 2)))
        ([?\s-4] . (lambda () (interactive) (exwm-workspace-switch 3)))
        ([?\s-h] . (lambda () (interactive) (exwm-switch-workspace-relative -1)))
        ([?\s-l] . (lambda () (interactive) (exwm-switch-workspace-relative 1)))
        ;; Cycle through windows on the current workspace.
        ([?\s-j] . (lambda () (interactive) (other-window 1)))
        ([?\s-k] . (lambda () (interactive) (other-window -1)))
        ;; Media keys.
        ([XF86AudioRaiseVolume] . (lambda () (interactive)
                                    (exwm-run-shell-command "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+ -l 1.0")))
        ([XF86AudioLowerVolume] . (lambda () (interactive)
                                    (exwm-run-shell-command "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-")))
        ([XF86AudioMute] . (lambda () (interactive)
                            (exwm-run-shell-command "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")))
        ([XF86MonBrightnessUp] . (lambda () (interactive)
                                   (exwm-run-shell-command "brightnessctl --class=backlight set +10%")))
        ([XF86MonBrightnessDown] . (lambda () (interactive)
                                     (exwm-run-shell-command "brightnessctl --class=backlight set 10%-")))))
(defun exwm-async-run (name)
  "Run a process asynchronously"
  (interactive)
  (start-process name nil name))

(defun run-or-raise-or-dismiss (program program-buffer-name)
  ""
  (if (string= (buffer-name) program-buffer-name)
      (bury-buffer)
    (progn
      (if (get-buffer program-buffer-name)
	  (progn
	    (if (get-buffer-window program-buffer-name)
		(select-window (display-buffer program-buffer-name) nil)
	      (exwm-workspace-switch-to-buffer program-buffer-name)))
	(exwm-async-run program)))))
(start-process "nm-applet" nil "nm-applet")
;; Let UDisks2 mount removable media for this user.  GVfs (used by
;; Thunar) will expose the resulting mounts in its sidebar.
(when (and (executable-find "udiskie")
           (not (process-live-p (get-process "udiskie"))))
  (start-process "udiskie" nil "udiskie" "--no-notify"))

;; Enable libinput's natural scrolling on every detected touchpad.
(start-process-shell-command
 "enable-natural-trackpad-scrolling" nil
 "for id in $(xinput list --short 2>/dev/null | sed -n 's/.*[Tt]ouchPad.*id=\\([0-9]*\\).*/\\1/p'); do xinput set-prop \"$id\" 'libinput Natural Scrolling Enabled' 1 2>/dev/null; done")

;; Configure RandR whenever monitors are connected or disconnected.  The
;; external output name is detected dynamically because it can vary depending
;; on which port or dock is in use.
(defun exwm-configure-monitors ()
  "Place the external monitor to the left of the laptop display."
  (let* ((laptop "eDP-1")
         (external
          (with-temp-buffer
            (when (= 0 (call-process "xrandr" nil t "--query"))
              (goto-char (point-min))
              (catch 'found
                (while (re-search-forward
                        "^\\([^[:space:]]+\\)[[:space:]]+connected\\(?:[[:space:]]\\|$\\)"
                        nil t)
                  (let ((output (match-string 1)))
                    (unless (string= output laptop)
                      (throw 'found output)))))))))
    (if external
        (when (= 0 (call-process "xrandr" nil nil nil
                                 "--output" laptop "--auto"
                                 "--output" external "--auto"
                                 "--left-of" laptop))
          ;; Keep workspace 0 on the external display; unspecified workspaces
          ;; remain on the primary (laptop) display.
          (setq exwm-randr-workspace-monitor-plist
                (list 0 external 1 laptop))
          (when exwm-randr--connection
            (exwm-randr-refresh)))
      (setq exwm-randr-workspace-monitor-plist nil)
      (when exwm-randr--connection       (exwm-randr-refresh)))))

(add-hook 'exwm-randr-screen-change-hook #'exwm-configure-monitors)
(exwm-randr-mode 1)
(exwm-wm-mode 1)

(provide 'exwm-config)
;;; exwm-config.el ends here
