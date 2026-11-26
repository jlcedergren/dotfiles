;;; my/notes/config.el -*- lexical-binding: t; -*-

(setq org-directory "~/org/")

(after! evil-org
  (evil-set-initial-state 'org-agenda-mode 'normal))

;; `(notes +timeedit)' in init.el
;; gets my uni calendar via ~/org/timeedit-sync.py (using ~/org/.venv).
(when (modulep! +timeedit)
  (defun my-timeedit-sync ()
    (interactive)
    (let ((org-dir (expand-file-name "~/org/")))
      (call-process
       (expand-file-name ".venv/bin/python" org-dir)
       nil
       "*timeedit-sync*"
       nil
       (expand-file-name "timeedit-sync.py" org-dir))
      (message "TimeEdit calendar updated"))))
