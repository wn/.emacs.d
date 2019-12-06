(setq visible-bell t)
(setq ring-bell-function 'ignore)
(put 'downcase-region 'disabled nil)
(setq custom-file "~/.emacs.d/custom.el")

;; Swap for Dvorak layout
(keyboard-translate ?\C-x ?\C-u)
(keyboard-translate ?\C-u ?\C-x)

(when (require 'redo nil 'noerror)
    (global-set-key (kbd "C-S-z") 'redo))

(global-set-key (kbd "C-z") 'undo)

(defalias 'yes-or-no-p 'y-or-n-p)
(defalias 'list-buffers 'ibuffer)

(show-paren-mode 1)
(tool-bar-mode -1)
(delete-selection-mode 1)

;; Cursor
(blink-cursor-mode 0)
(setq-default cursor-type 'bar)

(when (version<= "26.0.50" emacs-version )
  (global-display-line-numbers-mode))

(require 'overcast-theme)
(load-theme 'overcast t)

(use-package org-bullets
  :ensure t
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

(winner-mode 1)
(use-package ace-window
    :ensure t
    :defer 1
    :config
    (set-face-attribute
     'aw-leading-char-face nil
     :foreground "deep sky blue"
     :weight 'bold
     :height 3.0)
    (set-face-attribute
     'aw-mode-line-face nil
     :inherit 'mode-line-buffer-id
     :foreground "lawn green")
    (setq aw-keys '(?a ?s ?d ?f ?j ?k ?l)
          aw-dispatch-always t
          aw-dispatch-alist
          '((?x aw-delete-window "Ace - Delete Window")
            (?c aw-swap-window "Ace - Swap Window")
            (?n aw-flip-window)
            (?v aw-split-window-vert "Ace - Split Vert Window")
            (?h aw-split-window-horz "Ace - Split Horz Window")
            (?m delete-other-windows "Ace - Maximize Window")
            (?g delete-other-windows)
            (?b balance-windows)
            (?u (lambda ()
                  (progn
                    (winner-undo)
                    (setq this-command 'winner-undo))))
            (?r winner-redo)))

    (when (package-installed-p 'hydra)
      (defhydra hydra-window-size (:color red)
        "Windows size"
        ("h" shrink-window-horizontally "shrink horizontal")
        ("j" shrink-window "shrink vertical")
        ("k" enlarge-window "enlarge vertical")
        ("l" enlarge-window-horizontally "enlarge horizontal"))
      (defhydra hydra-window-frame (:color red)
        "Frame"
        ("f" make-frame "new frame")
        ("x" delete-frame "delete frame"))
      (defhydra hydra-window-scroll (:color red)
        "Scroll other window"
        ("n" joe-scroll-other-window "scroll")
        ("p" joe-scroll-other-window-down "scroll down"))
      (add-to-list 'aw-dispatch-alist '(?w hydra-window-size/body) t)
      (add-to-list 'aw-dispatch-alist '(?o hydra-window-scroll/body) t)
      (add-to-list 'aw-dispatch-alist '(?\; hydra-window-frame/body) t))
    (ace-window-display-mode t))

;; it looks like counsel is a requirement for swiper
(use-package counsel
  :ensure t
  )

(use-package swiper
  :ensure try
  :config
  (progn
    (ivy-mode 1)
    (setq ivy-use-virtual-buffers t)
    (global-set-key "\C-s" 'swiper)
    (global-set-key (kbd "C-c C-r") 'ivy-resume)
    (global-set-key (kbd "<f6>") 'ivy-resume)
    (global-set-key (kbd "M-x") 'counsel-M-x)
    (global-set-key (kbd "C-x C-f") 'counsel-find-file)
    (global-set-key (kbd "<f1> f") 'counsel-describe-function)
    (global-set-key (kbd "<f1> v") 'counsel-describe-variable)
    (global-set-key (kbd "<f1> l") 'counsel-load-library)
    (global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
    (global-set-key (kbd "<f2> u") 'counsel-unicode-char)
    (global-set-key (kbd "C-c g") 'counsel-git)
    (global-set-key (kbd "C-c j") 'counsel-git-grep)
    (global-set-key (kbd "C-c k") 'counsel-ag)
    (global-set-key (kbd "C-x l") 'counsel-locate)
    (global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
    (define-key read-expression-map (kbd "C-r") 'counsel-expression-history)
    ))

(define-key ivy-minibuffer-map (kbd "<ESC>") 'minibuffer-keyboard-quit)
(define-key swiper-map (kbd "<ESC>") 'minibuffer-keyboard-quit)

;; Used to try out custom packages on MELPA.
;; M-x try <package_name>
(use-package try
  :ensure t)

;; Displays the key bindings following currently entered incomplete command
(use-package which-key
  :ensure t
  :config
  (which-key-mode))

(use-package auto-complete
  :ensure t
  :init
  (progn
    (ac-config-default)
    (global-auto-complete-mode t)
    ))

(use-package yasnippet
  :ensure t
  :init
  (yas-global-mode 1))

(use-package flycheck
  :ensure t
  :init
  (global-flycheck-mode t))

(setq python-shell-interpreter "python3")
(setq flycheck-python-pycompile-executable "python3"
      flycheck-python-pylint-executable "python3"
      flycheck-python-flake8-executable "python3")
(with-eval-after-load 'python
  (defun python-shell-completion-native-try ()
    "Return non-nil if can trigger native completion."
    (let ((python-shell-completion-native-enable t)
          (python-shell-completion-native-output-timeout
           python-shell-completion-native-try-output-timeout))
      (python-shell-completion-native-get-completions
       (get-buffer-process (current-buffer))
       nil "_"))))
(use-package jedi
:ensure t
:init
(add-hook 'python-mode-hook 'jedi:setup)
(add-hook 'python-mode-hook 'jedi:ac-setup))

(use-package elpy
  :ensure t
  :config
  (elpy-enable))
