;;; my/dired/config.el -*- lexical-binding: t; -*-

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
