(defun mj-indent-line ()
  (interactive)
  (beginning-of-line)
  (if (bobp)
      (indent-line-to 0)
    (let ((cur-indent -1))
      (save-excursion
	(while (= cur-indent -1)
	  (forward-line -1)
	  (if (looking-at ".+$")
	      (if (looking-at ".*[{[(]$")
		  (setq cur-indent (+ (current-indentation) tab-width))
		(setq cur-indent (current-indentation)))
	    (if (bobp) (setq cur-indent 0)))))
      (indent-line-to cur-indent))))

(defun mj-tab ()
  (interactive)
  (let ((start (line-beginning-position))
	(end (point)))
    (if (or (= start end)
	    (and (<= end (line-end-position))
		 (string-match "^[ \t]*$" (buffer-substring start end))))
	(mj-indent-line)
      (insert-char ?\  (- tab-width (% (current-column) tab-width))))))

(defun mj-del ()
  (interactive)
  (let* ((len (+ 1 (% (- (current-column) 1) tab-width)))
	 (end (point))
	 (start (- end len)))
    (if (and (> len 0)
	     (string= (buffer-substring start end)
		      (make-string len ?\ )))
	(delete-region start end)
      (delete-backward-char 1))))

(defvar mj-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "TAB") 'mj-tab)
    (define-key map (kbd "DEL") 'mj-del)
    map))

(add-to-list 'auto-mode-alist '("\\.js\\'" . mj-mode))

(defun mj-mode ()
  (interactive)
  (kill-all-local-variables)
  (use-local-map mj-mode-map)
  (set (make-local-variable 'indent-tabs-mode) nil)
  (set (make-local-variable 'tab-width) 2)
  (set (make-local-variable 'comment-start) "// ")
  (set (make-local-variable 'comment-start-skip) "//+\\s-*")
  (set (make-local-variable 'require-final-newline) t)
  (setq major-mode 'mj-mode)
  (setq mode-name "mj"))

(provide 'mj-mode)
