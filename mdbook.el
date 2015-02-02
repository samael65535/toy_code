(require 'request)
(require 'json)

(defun show-books (items)
  (switch-to-buffer-other-window "*test*")
  (md-book-mode)
  (setq buffer-read-only nil)
  (erase-buffer)
  (set (make-local-variable 'i) 0)
  (while (< i (length items))
	(set (make-local-variable 'book) (elt items i))
	(insert (propertize (format "[%s]" (assoc-default 'title book)) 'face '(:foreground "SpringGreen")))
	(insert ":")
	(insert (propertize (format "<%s>\n" (assoc-default 'alt book)) 'face '(:foreground "DeepSkyBlue")))p
	(setq i (1+ i))
	)
  (setq buffer-read-only t)
  )

(defun search-db-book (title)
  (interactive "s[TITlE]:")
  (let (
		(a (cons "q" title))
		(b (cons "fields" "title,alt"))
		)
	(message "%s" (list a b))
	(request
	 "https://api.douban.com/v2/book/search"
	 :params (list a b)
	 :parser 'json-read
	 :success (function*
			   (lambda (&key data &allow-other-keys)
				 ;;(message "%s" (assoc-default 'books data))
				 (show-books (assoc-default 'books data))
				 )))
	)
  )

(defun select-book ()
  (interactive)
  (let ((url (thing-at-point 'line)))
	(delete-window)
	(insert url)
	)
  ;;(switch-to-buffer-other-window (other-buffer (current-buffer) ))
  )
(defvar md-book-mode-map
  (let ((map (make-sparse-keymap)))
	;; navigation
	(define-key map (kbd "RET")             'select-book)
	map)
  "Keymap for `md-book-mode'.")

(define-derived-mode md-book-mode markdown-mode nil "list"
  "Major mode for viewing a list.")

(provide 'md-book)

