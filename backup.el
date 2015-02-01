(require 'request)
(require 'json)
(defun hello-world (items)
  (switch-to-buffer-other-window "*test*")
  (md-book-mode)
  (setq buffer-read-only nil)
  (erase-buffer)
  (set (make-local-variable 'i) 0)
  (while (< i (length items))
	(set (make-local-variable 'book) (elt items i))
	(insert (propertize (format "[%s]" (assoc-default 'title book)) 'face '(:foreground "SpringGreen")))
	(insert ":")
	(insert (propertize (format "<%s>\n" (assoc-default 'alt book)) 'face '(:foreground "DeepSkyBlue")))
	(setq i (1+ i))
	)
  (setq buffer-read-only t)
  )


(defun search-book (title)
  (interactive "s[TITlE]:")
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
				 ;;(message "%s" (assoc-default 'books data))
				 (hello-world (assoc-default 'books data))
				 ))
	 )
	)
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

(define-derived-mode md-book-mode nil "list"
  "Major mode for viewing a list.")

(provide 'backup)
