(require 'package)

(package-initialize)

;; source point to China
(when (>= emacs-major-version 24)
  (setq package-archives '(("gnu"   . "http://elpa.emacs-china.org/gnu/")
                           ("melpa"   . "http://elpa.emacs-china.org/melpa/")
                           )))

;; get from Purcell
(defun require-package (package &optional min-version no-refresh)
  "Install given PACKAGE, optionally requiring MIN-VERSION.
 If NO-REFRESH is non-nil, the available package lists will not be
 re-downloaded in order to locate PACKAGE."
  (add-to-list 'package-selected-packages package)
  (if (package-installed-p package min-version)
      t
    (if (or (assoc package package-archive-contents) no-refresh)
        (if (boundp 'package-selected-packages)
            ;; Record this as a package the user installed explicitly
            (package-install package nil)
          (package-install package))
      (progn
        (package-refresh-contents)
        (require-package package min-version t)))))


(when (not package-archive-contents)
    (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(require-package 'auto-complete)
(ac-config-default)
(define-key ac-mode-map (kbd "M-TAB") 'auto-complete)

(add-to-list 'load-path "~/.emacs.d/custom")

;;http://tuhdo.github.io/c-ide.html 一定要看写的太好了
;; (require 'setup-general)
;; (if (version< emacs-version "24.4")
    ;; (require 'setup-ivy-counsel)
;;   (require 'setup-helm)
;;   (require 'setup-helm-gtags))
;;(require 'setup-ggtags)
;; (require 'setup-cedet)
;; (require 'setup-editing)
;;(require 'setup-company)



(require-package 'exec-path-from-shell)
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

(add-to-list 'load-path "~/.emacs.d/init")
(require 'init-defaults)
(require 'init-evil)
(require 'init-js)
(require 'init-ivy)
(require 'init-c)
(require 'init-ycmd)

(require-package 'helm-themes)
(require 'helm-themes)
;; (require 'helm-config)

(require-package 'afternoon-theme)
(load-theme 'afternoon t)

(require-package 'dash)
(eval-after-load 'dash '(dash-enable-font-lock))

(require-package 'neotree)
(global-set-key [f8] 'neotree-toggle)

;;cedet
;; (load-file (concat user-emacs-directory "/cedet/cedet-devel-load.el"))
;; (load-file (concat user-emacs-directory "cedet/contrib/cedet-contrib-load.el"))
(require-package 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)

(require-package 'clean-aindent-mode)
(set 'clean-aindent-is-simple-indent t)
(defun my-pkg-init()
  (electric-indent-mode -1)  ; no electric indent, auto-indent is sufficient
  (clean-aindent-mode t)
  (setq clean-aindent-is-simple-indent t)
  (define-key global-map (kbd "RET") 'newline-and-indent))
(add-hook 'after-init-hook 'my-pkg-init)
(define-key global-map (kbd "RET") 'newline-and-indent)

(require-package 'dtrt-indent)
(dtrt-indent-mode 1)
(setq dtrt-indent-verbosity 0)

(require-package 'ws-butler)
(add-hook 'c-mode-common-hook 'ws-butler-mode)

(require-package 'yasnippet)
(yas-global-mode 1)

(require-package 'realgud)

(require-package 'smartparens)
(require 'smartparens-config)
(show-smartparens-global-mode +1)
(smartparens-global-mode 1)
;; when you press RET, the curly braces automatically
;; add another newline
(sp-with-modes '(c-mode c++-mode)
  (sp-local-pair "{" nil :post-handlers '(("||\n[i]" "RET")))
  (sp-local-pair "/*" "*/" :post-handlers '((" | " "SPC")
                                            ("* ||\n[i]" "RET"))))

(global-set-key (kbd "<f5>") (lambda ()
                               (interactive)
                               (setq-local compilation-read-command nil)
                               (call-interactively 'compile)))

(setq
 ;; use gdb-many-windows by default
 gdb-many-windows t

 ;; Non-nil means display source file containing the main routine at startup
 gdb-show-main t
 )

(require-package 'company)
(add-hook 'after-init-hook 'global-company-mode)
(setq companyabbrev-downcase nil)
(setq company-minimum-prefix-length 2)
(with-eval-after-load 'company 
  (define-key company-active-map (kbd "M-n") nil)
  (define-key company-active-map (kbd "M-p") nil)
  (define-key company-active-map (kbd "C-n") #'company-select-next)
  (define-key company-active-map (kbd "C-p") #'company-select-previous)
  )

;; function-args
;; (require 'function-args)
;; (fa-config-default)
;; (define-key c-mode-map  [(tab)] 'company-complete)
;; (define-key c++-mode-map  [(tab)] 'company-complete)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
 (quote
  ("fa2b58bb98b62c3b8cf3b6f02f058ef7827a8e497125de0254f56e373abee088" "cdfc5c44f19211cfff5994221078d7d5549eeb9feda4f595a2fd8ca40467776c" "bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" default)))
 '(package-selected-packages
 (quote
  (zygospore helm-gtags helm yasnippet ws-butler volatile-highlights use-package undo-tree iedit dtrt-indent counsel-projectile company clean-aindent-mode anzu)))
 '(safe-local-variable-values (quote ((ggtags-process-environment "GTAGSLABEL=ctags")))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
