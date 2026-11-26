;;; my/dev/config.el -*- lexical-binding: t; -*-

(when (featurep :system 'macos)
  (setenv "DOTNET_ROOT" "/usr/local/share/dotnet"))

(after! eglot
  (setq eglot-events-buffer-config '(:size 2000000 :format full)
        eglot-events-buffer-size 2000000))
