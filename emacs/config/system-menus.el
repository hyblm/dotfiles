;;; system-menus.el --- Desktop menus -*- lexical-binding: t; -*-

(defun my/system-menu--call (program &rest args)
  "Run PROGRAM with ARGS, or signal a useful error."
  (unless (executable-find program)
    (user-error "%s is not installed" program))
  (let ((status (apply #'call-process program nil nil nil args)))
    (unless (and (integerp status) (= status 0))
      (user-error "%s failed" program))))

(defun my/system-menu--output (program &rest args)
  "Run PROGRAM with ARGS and return its output."
  (unless (executable-find program)
    (user-error "%s is not installed" program))
  (with-temp-buffer
    (let ((status (apply #'call-process program nil t nil args)))
      (unless (and (integerp status) (= status 0))
        (user-error "%s failed" program))
      (buffer-string))))

(defun my/audio-output-menu ()
  "Select the default PulseAudio/PipeWire output." 
  (interactive)
  (let* ((default (string-trim (my/system-menu--output "pactl" "get-default-sink")))
         (text (my/system-menu--output "pactl" "list" "sinks"))
         sinks name desc)
    (dolist (line (split-string text "\n"))
      (cond
       ((string-match "^Sink #[0-9]+" line)
        (when name (push (list name desc) sinks))
        (setq name nil desc nil))
       ((string-match "^[[:space:]]*Name: \\(.+\\)$" line)
        (setq name (match-string 1 line)))
       ((string-match "^[[:space:]]*Description: \\(.+\\)$" line)
        (setq desc (match-string 1 line)))))
    (when name (push (list name desc) sinks))
    (setq sinks (nreverse sinks))
    (unless sinks (user-error "No audio outputs found"))
    (let* ((choices (mapcar (lambda (sink)
                              (cons (format "%s %s" (if (string= (car sink) default) "󰓃" "󰓄") (cadr sink)) sink)) sinks))
           (choice (completing-read "Audio output: " choices nil t))
           (sink (cdr (assoc choice choices))))
      (my/system-menu--call "pactl" "set-default-sink" (car sink))
      (dolist (line (split-string (my/system-menu--output "pactl" "list" "short" "sink-inputs") "\n" t))
        (let ((input (car (split-string line))))
          (my/system-menu--call "pactl" "move-sink-input" input (car sink))))
      (when (executable-find "notify-send")
        (my/system-menu--call "notify-send" "Audio output switched" (cadr sink))))))

(defun my/power-profile-menu ()
  "Select the system power profile."
  (interactive)
  (let* ((text (my/system-menu--output "powerprofilesctl" "list"))
         profiles)
    (dolist (line (split-string text "\n" t))
      (when (string-match "^[[:space:]]*\\*?[[:space:]]*\\([a-z-]+\\):" line)
        (push (match-string 1 line) profiles)))
    (setq profiles (delete-dups (nreverse profiles)))
    (unless profiles (user-error "No power profiles found"))
    (let* ((choice (completing-read "Power profile: " profiles nil t))
           (profile choice))
      (my/system-menu--call "powerprofilesctl" "set" profile)
      (when (executable-find "notify-send")
        (my/system-menu--call "notify-send" "Power profile switched" profile)))))

(defun my/theme-menu (&optional choice)
  "Switch the desktop theme, or toggle it when CHOICE is nil." 
  (interactive)
  (let* ((state-file (expand-file-name "color-scheme" (or (getenv "XDG_STATE_HOME") "~/.local/state")))
         (current (if (file-readable-p state-file) (string-trim (with-temp-buffer (insert-file-contents state-file) (buffer-string))) "dark"))
         (choice (or choice (completing-read "Theme: " '("󰜉 Toggle" "󰖨 Light" "󰖔 Dark") nil t)))
         (mode (cond ((string-match-p "Toggle" choice) (if (string= current "dark") "light" "dark"))
                     ((string-match-p "Light" choice) "light")
                     (t "dark")))
         (scheme (if (string= mode "dark") "prefer-dark" "default")))
    (make-directory (file-name-directory state-file) t)
    (my/system-menu--call "gsettings" "set" "org.gnome.desktop.interface" "color-scheme" scheme)
    (my/system-menu--call "gsettings" "set" "org.gnome.desktop.interface" "gtk-application-prefer-dark-theme" (if (string= mode "dark") "true" "false"))
    (with-temp-file state-file (insert mode "\n"))
    ;; Changing GTK settings does not change Emacs's theme by itself.
    (my/sync-theme-with-system)
    (when (executable-find "notify-send")
      (my/system-menu--call "notify-send" "Theme switched" mode))))

(defun my/bluetooth-menu ()
  "Select a paired Bluetooth device and connect or disconnect it."
  (interactive)
  (unless (executable-find "bluetoothctl")
    (user-error "bluetoothctl is not installed"))
  (let ((paired (with-temp-buffer
                  (call-process "bluetoothctl" nil t nil "devices" "Paired")
                  (buffer-string)))
        (connected (with-temp-buffer
                     (call-process "bluetoothctl" nil t nil "devices" "Connected")
                     (buffer-string)))
        devices)
    (dolist (line (split-string paired "\n" t))
      (when (string-match "^Device[[:space:]]+\\([^[:space:]]+\\)[[:space:]]+\\(.+\\)$" line)
        (let* ((mac (match-string 1 line))
               (name (match-string 2 line))
               (is-connected
                (string-match-p
                 (concat "^Device[[:space:]]+" (regexp-quote mac)
                         "[[:space:]]") connected)))
          (push (cons (format "%s %s" (if is-connected "󰂱" "󰂲") name)
                      (list mac name is-connected)) devices))))
    (unless devices
      (user-error "No paired Bluetooth devices found"))
    (let* ((choice (completing-read "Bluetooth: " (nreverse devices) nil t))
           (device (cdr (assoc choice devices)))
           (mac (nth 0 device))
           (name (nth 1 device))
           (action (if (nth 2 device) "disconnect" "connect")))
      (if (= 0 (apply #'call-process "bluetoothctl" nil nil nil (list action mac)))
          (when (executable-find "notify-send")
            (my/system-menu--call "notify-send"
                                  (format "Bluetooth %s" action) name))
        (user-error "Could not %s %s" action name)))))

(defun my/session-menu--run (action description &rest args)
  "Confirm and invoke loginctl ACTION, describing it as DESCRIPTION."
  (unless (executable-find "loginctl")
    (user-error "loginctl is not installed"))
  (when (yes-or-no-p (format "%s? " description))
    (unless (= 0 (apply #'call-process "loginctl" nil nil nil action args))
      (user-error "Could not %s" (downcase description)))))

(defun my/session-menu ()
  "Choose a session or power action."
  (interactive)
  (pcase (completing-read
          "Session: "
          '("󰍃 Log out" "󰜉 Reboot" "󰐥 Power off" "󰒲 Hibernate" "󰤄 Suspend")
          nil t)
    ((pred (string-match-p "Log out"))
     ;; Terminate only this graphical login session, rather than every session
     ;; owned by the user.
     (let ((session-id (getenv "XDG_SESSION_ID")))
       (unless (and session-id (not (string-empty-p session-id)))
         (user-error "XDG_SESSION_ID is not set; cannot determine session to log out"))
       (my/session-menu--run "terminate-session" "Log out" session-id)))
    ((pred (string-match-p "Reboot"))
     (my/session-menu--run "reboot" "Reboot the system"))
    ((pred (string-match-p "Power off"))
     (my/session-menu--run "poweroff" "Power off the system"))
    ((pred (string-match-p "Hibernate"))
     (my/session-menu--run "hibernate" "Hibernate the system"))
    ((pred (string-match-p "Suspend"))
     (my/session-menu--run "suspend" "Suspend the system"))))

(defun my/system-menu ()
  "Open the desktop system menu."
  (interactive)
  (pcase (completing-read "Menu: " '("󰖨 Theme" "󰓃 Audio output" "󰂯 Bluetooth" "󰌪 Power profile" "󰐥 Session") nil t)
    ((pred (string-match-p "Theme")) (my/theme-menu))
    ((pred (string-match-p "Audio")) (my/audio-output-menu))
    ((pred (string-match-p "Bluetooth")) (my/bluetooth-menu))
    ((pred (string-match-p "Power profile")) (my/power-profile-menu))
    ((pred (string-match-p "Session")) (my/session-menu))))

(provide 'system-menus)
