;;; setup-deft --- configure deft notaional velocity equivalent
;;; COMMENTARY:
;;; CODE:

(when (require 'deft nil 'noerror)
  (setq deft-extension "org"
        deft-directory "~/Documents/deft"
        deft-text-mode 'org-mode)
  (global-set-key (kbd "<f9>") 'deft))

(provide 'setup-deft)
;;; setup-deft.el ends here
