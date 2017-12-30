(require-package 'company)
(add-hook 'after-init-hook 'global-company-mode)

(setq company-backends (delete 'company-semantic company-backends))
(define-key c-mode-map  [(tab)] 'company-complete)
(define-key c++-mode-map  [(tab)] 'company-complete)

(require-package 'company-c-headers)
(add-to-list 'company-backends 'company-c-headers)

(provide 'setup-company)
