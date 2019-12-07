;;; init.el --- Initialization file for Emacs


;;; Commentary:
;; Emacs Startup File --- initialization for Emacs

;;; Code:
(setq inhibit-startup-message t)

(require 'package)
(setq package-enable-at-startup nil)
(tool-bar-mode -1)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/"))

(package-initialize)

;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(org-babel-load-file (expand-file-name "~/.emacs.d/config.org"))

(provide 'init)

;;; init.el ends here
