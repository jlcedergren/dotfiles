;;; my/mail/config.el -*- lexical-binding: t; -*-

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
   "jill@jillcedergren.com"
   '((user-full-name     . "Jill Cedergren")
     (user-mail-address  . "jill@jillcedergren.com")
     (smtpmail-smtp-user . "jill.cedergren@proton.me")
     (smtpmail-smtp-server  . "127.0.0.1")
     (smtpmail-smtp-service . 1025))))
