;;; -*- lexical-binding: t; -*-
;;; zenbones-themes.el --- Shared Zenbones theme settings

(defgroup zenbones nil
  "Customization for the Zenbones themes."
  :group 'faces)

(defcustom zenbones-neutral-background nil
  "Use Flexoki backgrounds instead of the default Zenbones backgrounds."
  :type 'boolean
  :group 'zenbones)

(defcustom zenbones-green-strings t
  "Give strings a green tint instead of the default blue-gray."
  :type 'boolean
  :group 'zenbones)

(defcustom zenbones-more-visible-comments t
  "Use a reddish tint for comments to make them more visible."
  :type 'boolean
  :group 'zenbones)

(defcustom zenbones-org-typescale 1.067
  "Pick the typescale for Org headings."
  :type '(choice
	  (const :tag "Minor Second" 1.067)
	  (const :tag "Major Second" 1.125)
	  (const :tag "Minor Third"  1.2)
	  (const :tag "Major Third"  1.25))
  :group 'zenbones)

(custom-set-faces
 `(org-document-title ((t (:height ,(expt zenbones-org-typescale 9)))))
 `(org-level-1 ((t (:height ,(expt zenbones-org-typescale 8)))))
 `(org-level-2 ((t (:height ,(expt zenbones-org-typescale 7)))))
 `(org-level-3 ((t (:height ,(expt zenbones-org-typescale 6)))))
 `(org-level-4 ((t (:height ,(expt zenbones-org-typescale 5)))))
 `(org-level-5 ((t (:height ,(expt zenbones-org-typescale 4)))))
 `(org-level-6 ((t (:height ,(expt zenbones-org-typescale 3)))))
 `(org-level-7 ((t (:height ,(expt zenbones-org-typescale 2)))))
 `(org-level-8 ((t (:height ,(expt zenbones-org-typescale 1))))))

(provide 'zenbones-themes)
;;; zenbones-themes.el ends here
