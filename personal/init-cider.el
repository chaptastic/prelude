;;; init-Nepal --- setup nrepl settings

;;; COMMENTARY:
;;; CODE:

(require 'cider)
(setq cider-hide-special-buffers t)
(setq cider-popup-stacktraces-in-repl nil)
(setq cider-history-file "~/.emacs.d/cider-history")

(defun clojure-mode-eldoc-hook ()
  "Turn on eldoc mode and enable on existing buffers."
  (add-hook 'clojure-mode-hook 'turn-on-eldoc-mode)
  (add-hook 'cider-interaction-mode-hook 'cider-turn-on-eldoc-mode)
  (cider-enable-on-existing-clojure-buffers))

(add-hook 'cider-connected-hook 'clojure-mode-eldoc-hook)

(defun tcl-setup-cider-mode ()
  "Settings for cider mode"
  (subword-mode)
  (smartparens-strict-mode +1)
  (rainbow-delimiters-mode))
(add-hook 'cider-mode-hook 'tcl-setup-cider-mode)

(defun nrepl (& args)
  (message "It's called cider now, jackass.")
  (apply 'cider args))
                                        ; (prelude-ensure-module-deps '(ac-cider
;                              cider-ritz))

;; (require 'ac-cider)
;; (eval-after-load "auto-complete"
;;   '(add-to-list 'ac-modes 'cider-mode))

;; (add-hook 'cider-mode-hook 'ac-cider-setup)

;; disabled due to cider change
; (load-file (expand-file-name "javert/cider-inspect.el"
;                              prelude-personal-dir))
; (define-key cider-mode-map (kbd "C-c C-i") 'cider-inspect)


; (require 'cider-ritz)

;; Ritz middleware
; (define-key cider-interaction-mode-map (kbd "C-c C-j") 'cider-javadoc)
; (define-key cider-mode-map (kbd "C-c C-j") 'cider-javadoc)
; (define-key cider-interaction-mode-map (kbd "C-c C-a") 'cider-ritz-apropos)
; (define-key cider-mode-map (kbd "C-c C-a") 'cider-ritz-apropos)

(defun servo-connect ()
  "Connect to CIDER servers for TomServo"
  (interactive)
  (cider "127.0.0.1" 40006)
  (cider "127.0.0.1" 40007))

(provide 'init-cider)
;;; init-cider.el ends here
