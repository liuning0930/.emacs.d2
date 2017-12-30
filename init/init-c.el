(require-package 'cc-mode)
(use-package cc-mode
  :init
  (define-key c-mode-map  [(tab)] 'company-complete)
  (define-key c++-mode-map  [(tab)] 'company-complete))

;; When use irony in MAC OS system, you need to google for searching the method to solve the server failed error
(require-package 'irony)
(require 'irony)
(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'objc-mode-hook 'irony-mode)

(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)

(defun my-irony-mode-hook ()
  ; 重新map comletion-at-point，使齐keymap 调用的是irony-completion-at-point-async
  (define-key irony-mode-map [remap completion-at-point]
    'irony-completion-at-point-async)
  (define-key irony-mode-map [remap complete-symbol]
    'irony-completion-at-point-async))

(add-hook 'irony-mode-hook 'my-irony-mode-hook)
(add-hook 'irony-mode-hook 'company-irony-setup-begin-commands)

(require 'company)
(require-package 'company-irony)
(setq company-backends (delete 'company-semantic company-backends))
(eval-after-load 'company
  '(add-to-list 'company-backends 'company-irony))

(setq company-idle-delay 0)
(define-key c-mode-map [(tab)] 'company-complete)
(define-key c++-mode-map [(tab)] 'company-complete)

(require-package 'company-irony-c-headers)
(eval-after-load 'company
  '(add-to-list
    'company-backends '(company-irony-c-headers company-irony)))

(require-package 'flycheck-irony)
(eval-after-load 'flycheck
  '(add-hook 'flycheck-mode-hook #'flycheck-irony-setup))

(require-package 'yasnippet)
(yas-global-mode t)
(define-key yas-minor-mode-map (kbd "<tab>") nil)
(define-key yas-minor-mode-map (kbd "TAB") nil)

;; (require-package 'c-eldoc)
;; (add-hook 'c-mode-hook 'c-turn-on-eldoc-mode)
;; (add-hook 'c++-mode-hook 'c-turn-on-eldoc-mode)

;; (require-package 'company-quickhelp)
;; (company-quickhelp-mode t)
;; (eval-after-load 'company
;;   '(define-key company-active-map (kbd "C-c h") #'company-quickhelp-manual-begin))


(provide 'init-c)
