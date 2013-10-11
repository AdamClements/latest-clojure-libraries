;;; latest-clojure-libraries.el --- Clojure dependency resolver

;; Copyright 2013 Adam Clements

;; Plugin:  Latest clojure libraries dependency resolver
;; Author:  Adam Clements <adam.clements@gmail.com>
;; URL:     http://github.com/AdamClements/latest-clojure-libraries/
;; Package-Requires: ((nrepl "0.2.0"))
;; Version: 0.4
;; License: Eclipse Public License

;;; Commentary:

;; Looks up the latest version of clojure libraries on clojars/maven
;; and automatically populates the buffer with the appropriate
;; dependency vector. Optionally uses pomegranate to load the
;; dependency directly into your running nrepl.

;; Then, use M-x latest-clojure-libraries-insert-dependency

;;; Code:

(require 'nrepl)

(defun lcl/get-version-vec (s)
  (when (string-match "[[].+? \".+?\"[]]" s)
    (match-string 0 s)))

(defun lcl/get-latest-clojure-library (package)
  (lcl/get-version-vec
   (shell-command-to-string
    (format "lein ancient latest %s" package package))))

(defun lcl/add-clojure-dependency (spec)
  (nrepl-send-string
   (concat "(require 'cemerick.pomegranate)"
           "(cemerick.pomegranate/add-dependencies"
           "  :coordinates '[" spec "]"
           "  :repositories (merge cemerick.pomegranate.aether/maven-central"
           "                       {\"clojars\" \"http://clojars.org/repo\"}))")
   (lambda (out) (message (print out)))))

;;;###autoload
(defun latest-clojure-libraries-insert-dependency (package inject)
  "Insert dependency for PACKAGE and optionally INJECT it into nrepl classpath."
  (interactive (list (read-string "Library name: ")
                     (when (nrepl-current-repl-buffer)
                       (y-or-n-p "Add to running nrepl's classpath (requires cemerick.pomegranate)?"))))
  (message "Searching...")
  (let ((spec (lcl/get-latest-clojure-library package)))
    (if spec
        (progn (message (concat "Found " spec))
               (insert spec)
               (when inject (lcl/add-clojure-dependency spec)))
      (error "Can't find %s, are you sure you have the correct spelling?" package))))

(provide 'latest-clojure-libraries)
;;; latest-clojure-libraries.el ends here
