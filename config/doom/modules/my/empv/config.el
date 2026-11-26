;;; my/empv/config.el -*- lexical-binding: t; -*-

;; Music and youtube player (mpv)

(use-package! empv
  :config
  (require 'url-util)

  (setq empv-subsonic-url "https://music.jillcedergren.com"
        empv-subsonic-username "jlc"
        empv-subsonic-password ;; Set in .authinfo
        (auth-source-pick-first-password :host "music.jillcedergren.com")
        empv-invidious-instance 'ivjs)

  (add-to-list 'empv-mpv-args "--log-file=/tmp/mpv.log")

  (when-let* ((profile (car (file-expand-wildcards
                           (expand-file-name
                            "~/Library/Application Support/librewolf/Profiles/*.default-default")))))
  (add-to-list 'empv-mpv-args
               (concat "--ytdl-raw-options=cookies-from-browser=firefox:" profile)))

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

  (map! :leader
        :desc "Music (empv)" "e" empv-map)

  (map! :map empv-map
        :prefix ("S" . "subsonic")
        "s" #'empv-subsonic-search
        "a" #'empv-subsonic-albums
        "r" #'empv-subsonic-artists
        "o" #'empv-subsonic-songs
        "p" #'my/empv-play-album))
