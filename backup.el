(require 'request)
(require 'json)
(defun search-book (title)
  (interactive "s[TAG]: ")
  (let (
		(a (cons "q" title))
		(b (cons "fields" "title,alt"))
		(c (cons "apikey" "070a25cf7b777d02151e716e72667706"))
		)
	(message "%s" (list a b c))
	(request
	 "https://api.douban.com/v2/book/search"
	 :params (list a b c)
	 :parser 'json-read
	 :success (function*
			   (lambda (&key data &allow-other-keys)
				 (setq books (assoc-default 'books data))
				 (message "title is %s" books)
				 (setq i 0)
				 (while (< i (length books))
				   (setq book (elt books i))
				   (message "title is %s" (assoc-default 'title book))
				   (message "url is %s" (assoc-default 'alt book))
				   (setq i (1+ i))
				   )
				 ))
	 )
	)
  )


(defun hello-world (name)
  (switch-to-buffer-other-window "*test*")
  (md-book-mode)
  (setq buffer-read-only nil)
  (erase-buffer)
  (insert (format "hello %s\n" name))
  (search-book name)
  (setq buffer-read-only t)
  )

(defun next-book ()
  (interactive)
  (forward-line 1)
  (message "next")
  )

(defun prev-book ()
  (interactive)
  (forward-line -1)
  (message "prev")
  )

(defun select-book ()
  (interactive)
  (message "select %s" (thing-at-point 'line))
  )


(defvar md-book-mode-map
  (let ((map (make-sparse-keymap)))
	;; navigation
	(define-key map (kbd "RET")             'select-book)
	map)
  "Keymap for `md-book-mode'.")

(define-derived-mode md-book-mode nil "list"
  "Major mode for viewing a list.")

(provide 'backup)
