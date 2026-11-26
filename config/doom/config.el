;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Settings for every machine. other settings in modules/my/
;; activate in the my section of init

;;; UI

(setq doom-theme 'doom-opera
      display-line-numbers-type t)

(let ((splash (expand-file-name "emacs.svg" doom-user-dir)))
  (when (file-exists-p splash)
    (setq fancy-splash-image splash)))

(if (featurep :system 'macos)
    (add-to-list 'default-frame-alist '(alpha . (90 . 90)))
  (add-to-list 'default-frame-alist '(alpha-background . 90)))

;;; general

(when (featurep :system 'macos)
  (setq browse-url-browser-function 'browse-url-default-macosx-browser))

(map! :n "ä" #'evil-end-of-line)

;; Make tools from nix visible to Emacs
(dolist (dir (list (expand-file-name "~/.nix-profile/bin")
                   "/nix/var/nix/profiles/default/bin"))
  (add-to-list 'exec-path dir)
  (setenv "PATH" (concat dir ":" (getenv "PATH"))))
