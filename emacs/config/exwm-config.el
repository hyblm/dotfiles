;; This file is intentionally loaded only by the EXWM session launcher.
(require 'exwm-randr)
;; Make Caps Lock act as Control for EXWM.
(call-process "setxkbmap" nil nil nil "-option" "ctrl:nocaps")
(setq exwm-workspace-number 4)
(add-hook 'exwm-update-class-hook
	  (lambda () (exwm-workspace-rename-buffer exwm-class-name)))

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
	([?\s-f] . exwm-layout-toggle-fullscreen)
	([?\s-t] . exwm-floating-toggle-floating)
	([?\s-q] . delete-window)
	([?\s-b] . balance-windows)
        ([?\s-w] . exwm-workspace-switch)
        ([?\s-p] . (lambda (cmd)
                     (interactive (list (read-shell-command "$ ")))
                     (start-process-shell-command cmd nil cmd)))
        ;; Workspace selection and navigation.
	,@(mapcar (lambda (i)
		    `(,(kbd (format "s-%d" i)) .
		      (lambda () (interactive) (exwm-workspace-switch-create ,i))))
		  (number-sequence 0 9))
        ([?\s-h] . (lambda () (interactive) (exwm-switch-workspace-relative -1)))
        ([?\s-l] . (lambda () (interactive) (exwm-switch-workspace-relative 1)))
        ;; Cycle through windows on the current workspace.
        ([?\s-j] . (lambda () (interactive) (other-window 1)))
        ([?\s-k] . (lambda () (interactive) (other-window -1)))
        ;; Media keys.
        ([XF86AudioRaiseVolume]  . (lambda () (interactive) (exwm-run-shell-command "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+ -l 1.0")))
        ([XF86AudioLowerVolume]  . (lambda () (interactive) (exwm-run-shell-command "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-")))
        ([XF86AudioMute]         . (lambda () (interactive) (exwm-run-shell-command "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")))
        ([XF86MonBrightnessUp]   . (lambda () (interactive) (exwm-run-shell-command "brightnessctl --class=backlight set +10%")))
        ([XF86MonBrightnessDown] . (lambda () (interactive) (exwm-run-shell-command "brightnessctl --class=backlight set 10%-")))))
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
;; Enable libinput's natural scrolling on every detected touchpad.
(start-process
 "enable-natural-trackpad-scrolling" nil
 "bash" "-c"
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
                                 "--output" external "--auto" "--primary"
                                 "--left-of" laptop))
          ;; Keep workspace 0 on the laptop display. Unspecified workspaces
          ;; follow the RandR primary output, which is the external display.
          (setq exwm-randr-workspace-monitor-plist
                (list 0 laptop 1 external))
          (when exwm-randr--connection
            (exwm-randr-refresh)))
      (setq exwm-randr-workspace-monitor-plist nil)
      (when exwm-randr--connection       (exwm-randr-refresh)))))

(add-hook 'exwm-randr-screen-change-hook #'exwm-configure-monitors)
(exwm-randr-mode 1)
(exwm-wm-mode 1)

(provide 'exwm-config)
;;; exwm-config.el ends here
