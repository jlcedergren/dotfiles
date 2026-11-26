;;; my/supercollider/config.el -*- lexical-binding: t; -*-

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

;; Dumb but supercollider doesnt work without this
(setenv "XDG_CONFIG_HOME" nil)
