;;; my/tidal/config.el -*- lexical-binding: t; -*-

;; Uses supercollider module

(add-to-list 'load-path (dir!))

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
