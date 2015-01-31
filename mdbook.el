(require 'request)
(require 'json)
(defun search-book (title)
  (interactive "s[TAG]: ")
  (let (
		(a (cons "q" title))
		(b (cons "fields" "title,alt"))
		)
	(message "A %s" a)
	(message "B %s" b)
	(message "C %s" (list a b))
	(request
	 "https://api.douban.com/v2/book/search"
	 :params (list a b)
	 :parser 'json-read
	 :success (function*
			   (lambda (&key data &allow-other-keys)
				 (setq books (assoc-default 'books data))
				 (setq i 0)
				 (while (< i (length books))
				   (setq book (elt books i))
				   (message "title is %s" (assoc-default 'title book))
				   (message "url is %s" (assoc-default 'alt book))
				   (setq i (1+ i))
				   ))))
	))

(message "ddd")
(search-book "三国")
(provide 'insert-book-url)
;;---------------------------------------
;; insert-book-url end here
