***NOTE: This library's functionality has been totally superceded by clj-refactor's add-library-dependency functionality, I recommend you use that instead. ***

## Latest clojure libraries resolver for Emacs

Looks up the latest version of clojure libraries on clojars/maven and
automatically populates the buffer with the appropriate dependency
vector. Optionally uses pomegranate to load the dependency directly into
your running nrepl.

### Installation:

Edit your .lein/profiles.clj :plugins vector to include `[lein-ancient "0.5.1"]`
and optionally add `[com.cemerick/pomegranate "0.2.0"]` to your :dependencies
vector if you want the feature which automatically adds the library to
your classpath without restarting the repl.

`latest-clojure-libraries` is available on both major `package.el` community
maintained repos -
[Marmalade](http://marmalade-repo.org/packages/) and
[MELPA](http://melpa.milkbox.net).

If you're not already using Marmalade, add this to your
`~/.emacs.d/init.el` (or equivalent) and load it with <kbd>M-x eval-buffer</kbd>.

```lisp
(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)
```

For MELPA the code you need to add is:

```lisp
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)
```

And then you can install `latest-clojure-libraries` with the following commands:

<kbd>M-x package-refresh-contents [RET]</kbd>

<kbd>M-x package-install [RET] latest-clojure-libraries [RET]</kbd>

or by adding this bit of Emacs Lisp code to your Emacs initialization file(`.emacs` or `init.el`):

```lisp
(unless (package-installed-p 'latest-clojure-libraries)
  (package-refresh-contents)
  (package-install 'latest-clojure-libraries))
```

### Usage:

#### Adding dependencies
<kbd>M-x latest-clojure-libraries-insert-dependency</kbd>


It will then ask you for "Library name:" (e.g. incanter), and whether
you want to attempt to add it to the classpath of your currently running
repl. It will then insert the dependency vector with the latest version
number at your current cursor position.

To make use of the feature which injects the library into the current
repl, you need pomegranate on your classpath. You can add this in your
.lein/profiles.clj and it will be available everywhere (leiningen
2). (note depending how you run your project this may not be visible and
you may need to put it in your :user :dependencies)

    {:dev {:dependencies [[com.cemerick/pomegranate "0.2.0"]]}}

#### Updating versions on existing dependencies

<kbd>M-x latest-clojure-libraries-update-dependency-version</kbd>

With your cursor on the name of a dependency, such as anywhere on
"org.clojure/clojure" in [org.clojure/clojure "1.4.0"], invoke this
command to update the version number to the latest version.


### Issues:

* Output from adding to the repl's classpath is currently a little ugly.
