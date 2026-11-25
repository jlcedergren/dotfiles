;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;;; UI

(setq doom-theme 'doom-opera
      display-line-numbers-type t
      fancy-splash-image "/Users/jillced/.config/emacs/emacs.svg")

(set-frame-parameter (selected-frame) 'alpha '(90 . 90))
(add-to-list 'default-frame-alist '(alpha . (90 . 90)))


;;; General

(add-to-list 'load-path (expand-file-name "lisp" doom-user-dir))

(setq browse-url-browser-function 'browse-url-default-macosx-browser)

(map! :n "ä" #'evil-end-of-line)

;; Make Nix-installed tools visible to Emacs
(dolist (dir (list (expand-file-name "~/.nix-profile/bin")
                   "/nix/var/nix/profiles/default/bin"))
  (add-to-list 'exec-path dir)
  (setenv "PATH" (concat dir ":" (getenv "PATH"))))

;;; Dired

(use-package! dired-subtree
  :after dired
  :config
  (map! :map dired-mode-map
        :n "TAB"       #'dired-subtree-toggle
        :n "<backtab>" #'dired-subtree-cycle))

(use-package! dired-narrow
  :after dired
  :config
  (map! :map dired-mode-map
        :n "/" #'dired-narrow))


;;; Org

(setq org-directory "~/org/")

(after! evil-org
  (evil-set-initial-state 'org-agenda-mode 'normal))

(defun my-timeedit-sync ()
  (interactive)
  (let ((org-dir (expand-file-name "~/org/")))
    (call-process
     (expand-file-name ".venv/bin/python" org-dir)
     nil
     "*timeedit-sync*"
     nil
     (expand-file-name "timeedit-sync.py" org-dir))
    (message "TimeEdit calendar updated")))


;;; Programming

(setenv "DOTNET_ROOT" "/usr/local/share/dotnet")

(after! eglot
  (setq eglot-events-buffer-config '(:size 2000000 :format full)
        eglot-events-buffer-size 2000000))

(after! cc-mode
  (add-hook 'c-mode-hook #'lsp!)
  (add-hook 'c++-mode-hook #'lsp!))


;;; Email

(add-to-list 'load-path "/opt/homebrew/opt/mu/share/emacs/site-lisp/mu/mu4e")

(after! mu4e
  (setq mu4e-update-interval 300)
  (add-hook 'mu4e-main-mode-hook #'mu4e-update-mail-and-index)

  (set-email-account!
   "jill.cedergren@proton.me"
   '((user-full-name     . "Jill Cedergren")
     (user-mail-address  . "jill.cedergren@proton.me")
     (smtpmail-smtp-user . "jill.cedergren@proton.me")
     (smtpmail-smtp-server  . "127.0.0.1")
     (smtpmail-smtp-service . 1025))
   t)

  (set-email-account!
   "jill@jillcedgren.com"
   '((user-full-name     . "Jill Cedergren")
     (user-mail-address  . "jill@jillcedergren.com")
     (smtpmail-smtp-user . "jill.cedergren@proton.me")
     (smtpmail-smtp-server  . "127.0.0.1")
     (smtpmail-smtp-service . 1025))))


;;; SuperCollider

(setq exec-path (append exec-path
                        '("/Applications/SuperCollider.app/Contents/MacOS/")))

(add-to-list 'load-path
             "/Users/jillced/Library/Application Support/SuperCollider/downloaded-quarks/scel/el")

(require 'sclang)

(setq sclang-command "/Applications/SuperCollider.app/Contents/MacOS/sclang")

(after! sclang
  (advice-add 'switch-to-buffer :around
              (lambda (orig buffer-or-name &rest args)
                (unless (equal (buffer-name (get-buffer buffer-or-name))
                               "*SCLang:Workspace*")
                  (apply orig buffer-or-name args))))

  (map! :map sclang-mode-map
        :localleader
        :desc "Start SuperCollider" "s" #'sclang-start))

(setenv "XDG_CONFIG_HOME" nil)


;;; Tidal

(setq tidal-interpreter "/Users/jillced/.ghcup/bin/ghci"
      tidal-boot-script-path
      "/Users/jillced/.local/state/cabal/store/ghc-9.10.3-fe9c/tdl-1.10.3-ba4efd96/share/BootTidal.hs")

(require 'haskell-mode)
(require 'tidal)

(defvar my/sc-support-dir
  (expand-file-name "~/Library/Application Support/SuperCollider/"))

(defvar my/sc-use-tidal-flag
  (expand-file-name "use-tidal" my/sc-support-dir))

(defun my/start-tidal-environment ()
  "Launch SuperCollider with the Tidal startup file, then start Tidal."
  (interactive)
  (write-region "" nil my/sc-use-tidal-flag nil 'silent)
  (start-process "SuperCollider" nil "open" "-a" "SuperCollider")
  (run-at-time
   "5 sec" nil
   (lambda ()
     (when (file-exists-p my/sc-use-tidal-flag)
       (delete-file my/sc-use-tidal-flag))))
  (run-at-time "6 sec" nil #'tidal-start-haskell))

(after! tidal
  (map! :map tidal-mode-map
        :n "C-<return>" #'tidal-run-multiple-lines
        (:localleader
         :desc "Start Tidal environment" "s" #'my/start-tidal-environment)))


;;; Music player (empv)

(use-package! empv
  :config
  (require 'url-util)

  (setq empv-subsonic-url "https://music.jillcedergren.com"
        empv-subsonic-username "jlc"
        empv-subsonic-password
        (auth-source-pick-first-password :host "music.jillcedergren.com")
        empv-invidious-instance 'ivjs)

  (add-to-list 'empv-mpv-args "--log-file=/tmp/mpv.log")

  (defun my/empv-encode-info (url)
    (pcase (split-string url empv--title-sep)
      (`(,uri ,data) (concat uri empv--title-sep (url-hexify-string data)))
      (_ url)))

  (defun my/empv-decode-info (args)
    (let ((path (car args)))
      (if (and path (string-match-p empv--title-sep path))
          (pcase-let ((`(,uri ,data) (split-string path empv--title-sep)))
            (cons (concat uri empv--title-sep (url-unhex-string data))
                  (cdr args)))
        args)))

  (advice-add 'empv--url-with-magic-info :filter-return #'my/empv-encode-info)
  (advice-add 'empv--extract-empv-metadata-from-path :filter-args #'my/empv-decode-info)

  (defun my/empv-play-album ()
    "Pick a Subsonic album and play all of it."
    (interactive)
    (let* ((albums (alist-get 'results
                              (empv--subsonic-request "getAlbumList2.view"
                                                      :type "alphabeticalByName"
                                                      :size "500")))
           (table (mapcar (lambda (a)
                            (cons (format "%s — %s"
                                          (alist-get 'artist a)
                                          (alist-get 'name a))
                                  a))
                          albums))
           (choice (completing-read "Play album: " table nil t)))
      (empv-subsonic-play (cdr (assoc choice table)))))
  (add-to-list 'empv-mpv-args
               "--ytdl-raw-options=cookies-from-browser=firefox:/Users/jillced/Library/Application Support/librewolf/Profiles/me7og5ja.default-default")
  (map! :leader
        :desc "Music (empv)" "e" empv-map)

  (map! :map empv-map
        :prefix ("S" . "subsonic")
        "s" #'empv-subsonic-search
        "a" #'empv-subsonic-albums
        "r" #'empv-subsonic-artists
        "o" #'empv-subsonic-songs
        "p" #'my/empv-play-album))
