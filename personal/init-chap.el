;;; init-chap  -- personalized init file

;;; Commentary:
;;;  Seriously?

;;; Code:

;; (setq debug-on-error 't)


(prelude-ensure-module-deps '(deft
                               erc
                               magithub
                               base16-theme
                               helm-ack
                               ack-menu
                               iy-go-to-char
                               multiple-cursors
                               expand-region
                               annoying-arrows-mode
                               color-theme-solarized
                               evil
                               evil-leader
                               evil-nerd-commenter
                               evil-paredit
                               surround
                               magit-gh-pulls
                               web-mode
                               restclient
                               rinari
                               ruby-block
                               sass-mode
                               powerline
                               ac-js2))


(load-theme 'solarized-dark t t)

(annoying-arrows-mode)

(add-hook 'before-save-hook
          (lambda () (delete-trailing-whitespace)))

(require 'deft)
(setq deft-extension "md")
(setq deft-directory "~/Dropbox/deft")
(setq deft-text-mode 'markdown-mode)

(setq cua-enable-cua-keys nil)
(cua-mode t)
(global-set-key (kbd "s-c") 'clipboard-kill-ring-save)
(global-set-key (kbd "s-x") 'clipboard-kill-region)
(global-set-key (kbd "s-v") 'clipboard-yank)

(server-start)

(global-set-key (kbd "M-m") 'iy-go-to-char)
(global-set-key (kbd "M-i") 'back-to-indentation)

;; key chords
(require 'key-chord)

; (key-chord-define-global "fg" 'iy-go-to-char)
; (key-chord-define-global "fd" 'iy-go-to-char-backward)
; (key-chord-define-global "gg" 'goto-line)
(key-chord-mode -1)


(require 'expand-region)
(require 'multiple-cursors)

(global-set-key (kbd "C-@") 'er/expand-region)
(global-set-key (kbd "C-!") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-#") 'mc/mark-next-like-this)

(global-set-key (kbd "C-c i") 'helm-imenu)
;; (global-set-key (kbd "C-x C-f") 'helm-find-files)
;; (global-set-key (kbd "C-x C-b") 'helm-buffers-list)
;; (helm-mode 1)

;; Define a keymap for mark object commands
(define-prefix-command 'mark-object-map)
(global-set-key (kbd "C-x m") 'mark-object-map)
(define-key mark-object-map (kbd "(") 'er/mark-inside-pairs)
(define-key mark-object-map (kbd ")") 'er/mark-outside-pairs)
(define-key mark-object-map (kbd "\"") 'er/mark-inside-quotes)
(define-key mark-object-map (kbd "'") 'er/mark-outside-quotes)
(define-key mark-object-map (kbd "w") 'er/mark-word)
(define-key mark-object-map (kbd "u") 'er/mark-url)
(define-key mark-object-map (kbd "e") 'er/mark-email)
(define-key mark-object-map (kbd "/") 'er/mark-comment)
(define-key mark-object-map (kbd "d") 'er/mark-defun)

(defun ido-define-keys ()
  (define-key ido-completion-map (kbd "C-n") 'ido-next-match)
  (define-key ido-completion-map (kbd "C-p") 'ido-prev-match))
(add-hook 'ido-setup-hook 'ido-define-keys)

(ido-everywhere 1)

(defun switch-buffer-with-project (arg)
  (interactive "p")
  (if (> arg 1)
      (ido-switch-buffer)
    (if (projectile-project-p)
        (projectile-switch-to-buffer)
      (ido-switch-buffer))))

(global-set-key (kbd "C-x b") 'switch-buffer-with-project)

;; (defun open-line-below ()
;;   "Open a new line below the current line."
;;   (interactive)
;;   (end-of-line)
;;   (newline)
;;   (indent-for-tab-command))

;; (defun open-line-above ()
;;   "Open a new line above the current one, move to it, and ident."
;;   (interactive)
;;   (move-beginning-of-line nil)
;;   (newline-and-indent)
;;   (forward-line -1)
;;   (indent-according-to-mode))

;; (global-set-key (kbd "S-<return>") 'open-line-below)
;; (global-set-key (kbd "C-S-<return>")' open-line-above)

;; The above section is replaced under prelude with:
;; prelude-smart-open-line S-<return>
;; prelude-smart-open-line-above C-S-<return>

(global-set-key (kbd "s-z") 'undo-tree-undo)

(setq ace-jump-mode-case-fold t)
(setq ace-jump-mode-use-query-char nil)
(setq ace-jump-mode-scope 'frame)

(require 'evil-nerd-commenter)
(global-set-key (kbd "M-;") 'evilnc-comment-or-uncomment-lines)
;; (global-set-key (kbd "M-:") 'evilnc-comment-or-uncomment-to-the-line)
(global-set-key (kbd "s-/") 'evilnc-comment-or-uncomment-lines)

;;; Set up EVIL mode
(defun setup-evil-mode ()
  "Require and turn on evil mode"
  (require 'evil)
  (require 'evil-leader)

  (evil-leader/set-key
    "f" 'helm-find-files
    "b" 'helm-buffers-list
    "e" 'helm-prelude
    "t" 'prelude-ido-goto-symbol
    "x" 'kill-buffer
    "ci" 'evilnc-comment-or-uncomment-lines
    "cl" 'evilnc-comment-or-uncomment-to-the-line)

  (evil-mode 1)
  (global-evil-leader-mode)
  (evil-leader/set-leader ",")

  (evil-define-key 'insert paredit-mode-map
    (kbd "(") 'paredit-open-round
    (kbd ")") 'paredit-close-round
    (kbd "M-)") 'paredit-close-round-and-newline
    (kbd "[") 'paredit-open-square
    (kbd "]") 'paredit-close-square
    (kbd "\"") 'paredit-doublequote
    (kbd "M-\"") 'paredit-meta-doublequote
    (kbd "\\") 'paredit-backslash
    (kbd ";") 'paredit-semicolon
    (kbd "M-;") 'paredit-comment-dwim
    (kbd "C-j") 'paredit-newline
    (kbd "C-d") 'paredit-forward-delete
    (kbd "DEL") 'paredit-backward-delete
    (kbd "C-k") 'paredit-kill
    (kbd "M-d") 'paredit-forward-kill-word
    (kbd "M-DEL") 'paredit-backward-kill-word)
  nil)

(electric-indent-mode +1)

;; setup ruby stuff
(require 'ruby-block)
(ruby-block-mode t)


(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))

(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

(setq web-mode-engines-alist
      '(("php" . "\\.phtml\\'")
        ("erb" . "\\.erb")))

(eval-after-load 'clojure-mode
  '(define-clojure-indent
     (describe 'defun)
     (it 'defun)
     (with 'defun)
     (with-all 'defun)
     (before 'defun)
     (before-all 'defun)
     (after 'defun)
     (after-all 'defun)))

(provide 'init-chap)
;;; init-chap.el ends here
