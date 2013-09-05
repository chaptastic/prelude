;; init-chap  -- personalized init file

;;; Commentary:
;;;  Seriously?

;;; Code:

;; (setq debug-on-error 't)

(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)

(prelude-ensure-module-deps '(deft
                               erc
                               epg epa
                               magithub
                               base16-theme
                               cyberpunk-theme
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
                               ido-vertical-mode
                               ido-ubiquitous
                               ac-js2
                               soothe-theme
                               buffer-move
                               org-plus-contrib
                               clojure-cheatsheet
                               irfc
                               gruber-darker-theme
                               hemisu-theme
                               ir-black-theme
                               )
                            )

(require 'epa-file)
(epa-file-enable)

(setq custom-theme-directory (expand-file-name "./themes/" prelude-personal-dir))
(add-to-list 'custom-theme-load-path custom-theme-directory)
(add-to-list 'load-path prelude-personal-dir)
;; (load-theme 'solarized-dark t t)
;;(load-theme 'soothe t t)
;;(enable-theme 'soothe)
(load-theme 'ir-black-chap t t)
(enable-theme 'ir-black-chap)

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
(ido-vertical-mode)

(require 'dash)

(defun promote-project-buffers (buffers project-root)
  (apply 'append
         (-separate (lambda (buf)
                      (projectile-project-buffer-p buf project-root))
                    buffers)))

(defadvice buffer-list (around projectile-aware-buffer-list activate)
  "Order buffers with current project first."
  (let ((results ad-do-it))
    (if (projectile-project-p)
        (let ((proj-root (projectile-project-root)))
         (promote-project-buffers results proj-root))
      results)))

(ad-activate 'buffer-list t)

;; (defun switch-buffer-with-project (arg)
;;   (interactive "p")
;;   (if (> arg 1)
;;       (ido-switch-buffer)
;;     (if (projectile-project-p)
;;         (projectile-switch-to-buffer)
;;       (ido-switch-buffer))))

;; (global-set-key (kbd "C-x b") 'switch-buffer-with-project)

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
     (after-all 'defun)
     (defroutes 'defun)
     (GET 2)
     (POST 2)
     (PUT 2)
     (DELETE 2)
     (HEAD 2)
     (ANY 2)
     (context 2)))

(require 'init-mu4e)

(setq irc-password
      (shell-command-to-string "python -c 'from __future__ import print_function; import keyring; print(keyring.get_password(\"irc\", \"chaptastic\"), end=\"\")'"))

(setq erc-nick "chaptastic"
      erc-hide-list '("JOIN" "PART" "QUIT"))

(defun irc-connect ()
  "Connect to freenode"
  (interactive)
  (erc :server "irc.freenode.net"
       :port 6667
       :nick erc-nick
       :password irc-password))


;; auto complete
;; (require 'auto-complete-config)
;; (add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
;; (ac-config-default)
;; (setq ac-delay 0.25) ;; eclipse uses 500ms

(add-hook 'clojure-mode-hook 'subword-mode) ()

(require 'init-nrepl)

(winner-mode 1)
(require 'buffer-move)
(global-set-key (kbd "<C-s-up>")     'buf-move-up)
(global-set-key (kbd "<C-s-down>")   'buf-move-down)
(global-set-key (kbd "<C-s-left>")   'buf-move-left)
(global-set-key (kbd "<C-s-right>")  'buf-move-right)

;;; Orgmode!
(require 'org-install)
(global-set-key "\C-ca" 'org-agenda)

(defvar dropbox-dir (expand-file-name "~/Dropbox"))

(setq org-directory (expand-file-name "./Org" dropbox-dir))
(setq org-mobile-directory (expand-file-name "./Apps/MobileOrg" dropbox-dir))
(setq org-agenda-files (list (expand-file-name "./chap-agenda.org" org-directory)))
(setq org-mobile-inbox-for-pull (expand-file-name "./inbox.org" org-mobile-directory))

(provide 'init-chap)
;;; init-chap.el ends here
