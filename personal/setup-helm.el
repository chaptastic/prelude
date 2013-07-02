;;; setup-helm --- configure settings for helm
;;; COMMENTARY:
;;; CODE:

;; (require 'helm-files)
;;(setq helm-idle-delay 0.1)
;;(setq helm-input-idle-delay 0.1)
;;(setq helm-c-locate-command "locate-with-mdfind %.0s %s")
;;(loop for ext in '("\\.swf$" "\\.elc$" "\\.pyc$")
;;      do (add-to-list 'helm-c-boring-file-regexp-list ext))
;;(define-key global-map [(alt t)] 'helm-for-files)

(helm-mode 1)
(provide 'setup-helm)
;;; setup-el.ends here helm
