## Latest clojars resolver for Emacs

Looks up the latest version of clojure libraries on clojars and automatically
populates the buffer with the appropriate dependency vector. Optionally uses
pomegranate to load the dependency directly into your running nrepl.

### Installation:

Requires *curl* to be installed on your system and accessible on your
$PATH, install with your package manager.

`latest-clojars` is available on both major `package.el` community
maintained repos -
[Marmalade](http://marmalade-repo.org/packages/nrepl) and
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

And then you can install `latest-clojars` with the following commands:

<kbd>M-x package-refresh-contents [RET]</kbd>

<kbd>M-x package-install [RET] latest-clojars [RET]</kbd>

or by adding this bit of Emacs Lisp code to your Emacs initialization file(`.emacs` or `init.el`):

```lisp
(unless (package-installed-p 'latest-clojars)
  (package-refresh-contents)
  (package-install 'latest-clojars))
```

### Usage:

M-x insert-clojars

It will then ask you for "Library name:" (e.g. incanter), and whether you want to
attempt to add it to the classpath of your currently running repl. It will then insert
theh dependency vector with the latest version number at your current cursor position.

To make use of the feature which injects the library into the current repl, you need
pomegranate on your classpath. You can add this in your .lein/profiles.clj and it will
be available everywhere (leiningen 2).

    {:user {:dependencies [[com.cemerick/pomegranate "0.0.13"]]}}

### Disclaimers:

* The method used to get the latest version from clojars is supremely hacky and
liable to break. Hopefully either someone can point me to, or create an API
to query this information more sensibly.

* Currently only works on clojars, not for things on maven central or in your own
repositories, sorry.

* Output from adding to the repl's classpath is currently a little ugly.
