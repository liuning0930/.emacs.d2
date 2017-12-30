(require-package 'evil-leader)

(require-package 'which-key)
(which-key-mode 1)
(setq which-key-side-window-max-height 0.25)
;; (which-key-add-key-based-replacements
;;   "<SPC>f" "File"
;;   "<SPC>d" "Directory"
;;   "<SPC>b" "Buffer"
;;   "<SPC>bl" "Blog"
;;   )

(require 'evil-leader)

(setq evil-leader/in-all-states t)
(setq evil-leader/leader "SPC")
(global-evil-leader-mode)
(evil-mode t)
(setq evil-leader/no-prefix-mode-rx '("w3m.*-mode" "cfw:calendar-mode")) ; w3m mode needs this too!

(evil-leader/set-key
  ;; file & buffer
  "ff" 'counsel-find-file
  "bb" 'ivy-switch-buffer
  "bk" 'kill-buffer
  "bn" 'next-buffer
  "bp" 'previous-buffer
  "wk" 'delete-other-windows
  "wh" 'split-window-horizontally
  "wv" 'split-window-vertically
  "wf" 'other-frame
  "er" 'eval-region
  "eb" 'eval-buffer
  "." 'repeat
  )

;; q for kill-buffer, not for exit emacss
(evil-ex-define-cmd "q" (lambda () (interactive) (kill-buffer (current-buffer))))
;; wq for save & kill-buffer, not for exit emacss
(evil-ex-define-cmd "wq" (lambda () (interactive) (save-buffer) (kill-buffer (current-buffer))))

(require-package 'evil)

(evil-mode 1)
(setq case-fold-search nil)

(require-package 'evil-nerd-commenter)

(evilnc-default-hotkeys)
(global-set-key (kbd "s-/") 'evilnc-comment-or-uncomment-lines)

(require-package 'evil-surround)

(global-evil-surround-mode 1)

(define-key evil-motion-state-map (kbd "s-F") 'counsel-projectile-ag)

(require-package 'evil-matchit)

(global-evil-matchit-mode 1)

(require-package 'evil-visualstar)
(global-evil-visualstar-mode)

(require-package 'evil-cleverparens)

(add-hook 'emacs-lisp-mode-hook #'evil-cleverparens-mode)
(setq evil-move-beyond-eol t)

(defun evil-visual-char-or-expand-region ()
  (interactive)
  (if (region-active-p)
        (call-interactively 'er/expand-region)
    (evil-visual-char)))

(define-key evil-normal-state-map "v" 'evil-visual-char-or-expand-region)
(define-key evil-visual-state-map "v" 'evil-visual-char-or-expand-region)
(define-key evil-visual-state-map [escape] 'evil-visual-char)

(require-package 'counsel-gtags)
(add-hook 'c-mode-hook 'counsel-gtags-mode)
(add-hook 'c++-mode-hook 'counsel-gtags-mode)

(with-eval-after-load 'counsel-gtags
  (define-key counsel-gtags-mode-map (kbd "M-t") 'counsel-gtags-find-definition)
  (define-key counsel-gtags-mode-map (kbd "M-r") 'counsel-gtags-find-reference)
  (define-key counsel-gtags-mode-map (kbd "M-s") 'counsel-gtags-find-symbol)
  (define-key counsel-gtags-mode-map (kbd "M-,") 'counsel-gtags-go-backward))

(provide 'init-evil)
