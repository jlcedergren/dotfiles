(package! dired-subtree)
(package! dired-narrow)

(package! empv)

(when (featurep :system 'macos)
  (package! haskell-mode)
  (package! scel
    :recipe (:host github :repo "supercollider/scel")))
