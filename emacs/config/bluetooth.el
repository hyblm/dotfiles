;;; bluetooth.el --- Bluetooth device menu -*- lexical-binding: t; -*-

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
      (if (= 0 (call-process "bluetoothctl" nil nil nil action mac))
          (call-process "notify-send" nil nil nil
                        (format "Bluetooth %s" action) name)
        (user-error "Could not %s %s" action name)))))

(provide 'bluetooth)
;;; bluetooth.el ends here
