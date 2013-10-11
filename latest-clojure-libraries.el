;;; latest-clojure-libraries.el --- Clojure dependency resolver

;; Copyright 2013 Adam Clements

;; Plugin:  Latest clojure libraries dependency resolver
;; Author:  Adam Clements <adam.clements@gmail.com>
;; URL:     http://github.com/AdamClements/latest-clojure-libraries/
;; Version: 0.4
;; License: Eclipse Public License

(defun get-version-vec (s)
  (when (string-match "[[].+? \".+?\"[]]" s)
    (match-string 0 s)))

(defun get-latest-clojure-library (package)
  (get-version-vec
   (shell-command-to-string
    (format "lein ancient latest %s" package package))))

(defun add-clojure-dependency (spec)
  (nrepl-send-string
   (concat "(require 'cemerick.pomegranate)"
           "(cemerick.pomegranate/add-dependencies"
           "  :coordinates '[" spec "]" 
           "  :repositories (merge cemerick.pomegranate.aether/maven-central"
           "                       {\"clojars\" \"http://clojars.org/repo\"}))")
   (lambda (out) (message (print out)))))

;;;###autoload
(defun insert-dependency (package inject?)
  (interactive (list (read-string "Library name: ")
                     (when (nrepl-current-repl-buffer) (y-or-n-p "Add to running nrepl's classpath (requires cemerick.pomegranate)?"))))
  (message "Searching...")
  (let ((spec (get-latest-clojure-library package)))
    (if spec
        (progn (message (concat "Found " spec))
               (insert spec)
               (if inject? (add-clojure-dependency spec)))
      (message (concat "Can't find " package ", are you sure you have the correct spelling?")))))

;;; latest-clojure-libraries.el ends here
