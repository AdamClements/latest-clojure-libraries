;;; latest-clojars.el --- Clojure dependency resolver

;; Copyright 2013 Adam Clements

;; Plugin:  Latest clojars dependency resolver
;; Author:  Adam Clements <adam.clements@gmail.com>
;; URL:     http://github.com/AdamClements/latest-clojure-libraries/
;; Version: 0.3
;; License: Eclipse Public License

(defun version-number (s)
  (when (string-match ">\\([0-9]+\\.[0-9]+\\.[0-9]+\\)<" s)
    (match-string 1 s)))

(defun get-latest-clojure-library (package)
  (let ((version (version-number
                  (shell-command-to-string
                   (format "curl -s https://clojars.org/%s | grep \"version&gt;\"" package)))))
    (if version (list package version) nil)))

(defun clojure-vec-dependency (spec)
  (format "[%s \"%s\"]" (first spec) (second spec)))


(defun add-clojure-dependency (spec)
  (nrepl-send-string
   (concat "(require 'cemerick.pomegranate)"
           "(cemerick.pomegranate/add-dependencies"
           "  :coordinates '[" spec "]"
           "  :repositories {\"clojars\" \"http://clojars.org/repo\"})")
   (lambda (out) (message (print out)))))

;;;###autoload
(defun insert-clojars (package inject?)
  (interactive (list (read-string "Library name: ")
                     (y-or-n-p "Add to running nrepl's classpath?")))
  (let ((lib-spec (get-latest-clojure-library package)))
    (if lib-spec
        (let ((spec (clojure-vec-dependency lib-spec)))
          (insert spec)
          (if inject? (add-clojure-dependency spec)))
      (message (concat "Can't find " package ", "
                       "are you sure you have the correct spelling? Is it definitely available on clojars and not a SNAPSHOT?")))))

;;; latest-clojars.el ends here
