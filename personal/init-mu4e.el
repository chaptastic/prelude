;; init-mu4e.el -- initialize mu4e mail client

;;; Commentary:

;;; Code:
(add-to-list 'load-path "/usr/local/share/emacs/site-lisp/mu4e")

(require 'mu4e)

(when (fboundp 'imagemagick-register-types) (imagemagick-register-types))

(defun work-msg-p (msg)
  (and msg
       (or (mu4e-message-contact-field-matches msg :to "@clickscape.com")
           (mu4e-message-contact-field-matches msg :from "@clickscape.com")
           (string-match "^/clickscape/" (mu4e-message-field msg :maildir)))))

(defun msg-account-part (msg)
  (if (work-msg-p msg)
      "/clickscape"
    "/gmail"))

(defun account-folder-path (msg folder)
  (concat (msg-account-part msg) folder))


(setq mu4e-maildir (expand-file-name "~/Mail")
      mu4e-sent-folder (lambda (msg)
                         (account-folder-path msg "/sent_mail"))
      mu4e-drafts-folder (lambda (msg) (account-folder-path msg "/drafts"))
      mu4e-trash-folder (lambda (msg) (account-folder-path msg "/trash"))
      mu4e-refile-folder (lambda (msg) (account-folder-path msg "/all_mail"))
      mu4e-headers-skip-duplicates t
      mu4e-view-show-images t
      mu4e-view-image-max-width 640

      mu4e-html2text-command "html2text -style pretty -nobs -utf8";; "w3m -dump -T text/html"
      message-kill-buffer-on-exit t
      mail-user-agent 'mu4e-user-agent

      message-send-mail-function 'message-send-mail-with-sendmail
      sendmail-program "/usr/local/bin/msmtp"

      user-full-name "Chap Lovejoy"
      mu4e-auto-retrieve-keys t
      mu4e-headers-fields (quote ((:human-date . 12) (:flags . 6) (:from . 22) (:subject)))
      mu4e-headers-include-related nil
      mu4e-headers-visible-lines 15
      mu4e-split-view nil
      mu4e-update-interval 600
      mu4e-use-fancy-chars nil
      mu4e-user-mail-address-list (quote ("chap@chaplovejoy.com" "chaplovejoy@gmail.com" "chap.lovejoy@clickscape.com" "chap@clickscape.com" "support@clickscape.com" "chap@chaptastic.net")))

(setq mu4e-bookmarks
      '(("(maildir:/gmail/inbox or maildir:/clickscape/inbox) and not flag:t"
         "Inbox" ?i)
        ("flag:unread AND NOT flag:trashed"
          "Unread messages"      ?u)
         ("date:today..now AND NOT flag:trashed"
          "Today's messages"     ?t)
         ("date:7d..now AND NOT flag:trashed"
          "Last 7 days"          ?w)
         ("mime:image/* AND NOT flag:trashed"
          "Messages with images" ?p)))
(setq mu4e-maildir-shortcuts
      '(("/gmail/INBOX" . ?i)
        ("/clickscape/INBOX" . ?w)
        ("/gmail/bacn" . ?b)))

(defvar my-mu4e-account-alist
  '(("gmail"
     (mu4e-sent-folder "/gmail/sent_mail")
     (mu4e-drafts-folder "/gmail/drafts")
     (user-mail-address "chaplovejoy@gmail.com")
     (message-sendmail-extra-arguments ("-a" "gmail")))
    ("clickscape"
     (mu4e-sent-folder "/clickscape/sent_mail")
     (mu4e-drafts-folder "/clickscape/drafts")
     (user-mail-address "chap.lovejoy@clickscape.com")
     (message-sendmail-extra-arguments ("-a" "clickscape")))))

    ;;; message view action
(defun mu4e-msgv-action-view-in-browser (msg)
  "View the body of the message in a web browser."
  (interactive)
  (let ((html (mu4e-msg-field (mu4e-message-at-point t) :body-html))
        (tmpfile (format "%s/%d.html" temporary-file-directory (random))))
    (unless html (error "No html part for this message"))
    (with-temp-file tmpfile
      (insert
       "<html>"
       "<head><meta http-equiv=\"content-type\""
       "content=\"text/html;charset=UTF-8\">"
       html))
    (browse-url (concat "file://" tmpfile))))

(add-to-list 'mu4e-view-actions
             '("browser" . mu4e-msgv-action-view-in-browser) t)

(defun my-mu4e-set-account ()
  "Set the account for composing a message."
  (let* ((account
          (if mu4e-compose-parent-message
              (let ((maildir (mu4e-message-field mu4e-compose-parent-message :maildir)))
                (string-match "/\\(.*?\\)/" maildir)
                (match-string 1 maildir))
            (completing-read (format "Compose with account: (%s) "
                                     (mapconcat #'(lambda (var) (car var)) my-mu4e-account-alist "/"))
                             (mapcar #'(lambda (var) (car var)) my-mu4e-account-alist)
                             nil t nil nil (caar my-mu4e-account-alist))))
         (account-vars (cdr (assoc account my-mu4e-account-alist))))
    (if account-vars
        (mapc #'(lambda (var)
                  (set (car var) (cadr var)))
              account-vars)
      (error "No email account found"))))

(add-hook 'mu4e-compose-pre-hook 'my-mu4e-set-account)

(provide 'init-mu4e)
