;;; init-Nepal --- setup nrepl settings

;;; COMMENTARY:
;;; CODE:

(require 'nrepl)
(setq nrepl-hide-special-buffers t)
(setq nrepl-popup-stacktraces-in-repl t)
(setq nrepl-history-file "~/.emacs.d/nrepl-history")

(defun clojure-mode-eldoc-hook ()
  "Turn on eldoc mode and enable on existing buffers."
  (add-hook 'clojure-mode-hook 'turn-on-eldoc-mode)
  (add-hook 'nrepl-interaction-mode-hook 'nrepl-turn-on-eldoc-mode)
  (nrepl-enable-on-existing-clojure-buffers))
(add-hook 'nrepl-connected-hook 'clojure-mode-eldoc-hook)

(add-hook 'nrepl-mode-hook 'subword-mode)


(prelude-ensure-module-deps '(ac-nrepl
                              nrepl-ritz))

(require 'ac-nrepl)
(eval-after-load "auto-complete"
  '(add-to-list 'ac-modes 'nrepl-mode))
(add-hook 'nrepl-mode-hook 'ac-nrepl-setup)

(load-file (expand-file-name "javert/nrepl-inspect.el"
                             prelude-personal-dir))
(define-key nrepl-mode-map (kbd "C-c C-i") 'nrepl-inspect)


(require 'nrepl-ritz)

;; Ritz middleware
(define-key nrepl-interaction-mode-map (kbd "C-c C-j") 'nrepl-javadoc)
(define-key nrepl-mode-map (kbd "C-c C-j") 'nrepl-javadoc)
(define-key nrepl-interaction-mode-map (kbd "C-c C-a") 'nrepl-ritz-apropos)
(define-key nrepl-mode-map (kbd "C-c C-a") 'nrepl-ritz-apropos)


(provide 'init-nrepl)
;;; init-nrepl.el ends here
