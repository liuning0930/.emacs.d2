(defun xah-syntax-color-hex ()
  "Syntax color text of the form 「#ff1100」 and 「#abc」 in current buffer.
  URL `http://ergoemacs.org/emacs/emacs_CSS_colors.html'
  Version 2017-03-12"
  (interactive)
  (font-lock-add-keywords
   nil
   '(("#[[:xdigit:]]\\{3\\}"
      (0 (put-text-property
          (match-beginning 0)
          (match-end 0)
          'face (list :background
                      (let* (
                             (ms (match-string-no-properties 0))
                             (r (substring ms 1 2))
                             (g (substring ms 2 3))
                             (b (substring ms 3 4)))
                        (concat "#" r r g g b b))))))
     ("#[[:xdigit:]]\\{6\\}"
      (0 (put-text-property
          (match-beginning 0)
          (match-end 0)
          'face (list :background (match-string-no-properties 0)))))))
  (font-lock-flush))

(add-hook 'web-mode-hook 'xah-syntax-color-hex)
(add-hook 'rjsx-mode-hook 'xah-syntax-color-hex)

(require-package 'js2-mode)
;; (require-package 'simple-httpd)
(setq js2-strict-trailing-comma-warning nil)

(require-package 'tide)
(require 'tide)
(require 'company)

(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)

  (setq company-tooltip-align-annotations t)

  ;; formats the buffer before saving
  ;; use prettier-js instead
  ;; (add-hook 'before-save-hook 'tide-format-before-save)

  (flycheck-add-mode 'javascript-eslint 'rjsx-mode)
  (flycheck-add-next-checker 'javascript-eslint 'jsx-tide 'append)

  ;; keys
  (evil-define-key 'normal tide-mode-map (kbd "s-.") 'tide-jump-to-definition)
  ;; 用全局的
  ;; (evil-define-key 'normal tide-mode-map (kbd "s-,") 'tide-jump-back)
  (evil-define-key 'normal tide-mode-map (kbd "s-h") 'tide-documentation-at-point)
  (evil-define-key 'normal tide-mode-map (kbd "s-i") 'imenu-list-smart-toggle)
  ;; 用js-doc的
  ;; (evil-define-key 'normal tide-mode-map (kbd "M-s-/") 'tide-jsdoc-template)
  ;; (evil-define-key 'normal tide-mode-map (kbd "M-s-÷") 'tide-jsdoc-template)

  (
   add-hook 'rjsx-mode-hook
            (lambda ()
              (set (make-local-variable 'company-backends)
                   '(
                     company-tide
                     company-dabbrev-code
                     company-keywords
                     company-files
                     company-yasnippet)))))

(add-hook 'rjsx-mode-hook #'setup-tide-mode)

(defadvice tide-eldoc-maybe-show (around fix-eldoc-maybe-show-too-long activate)
  "Fix tide too long message mini buffer."
  (when (< (length text) 1000)
    ad-do-it))

(require-package 'js-doc)
(require 'js-doc)

(setq js-doc-mail-address (s-trim-right (shell-command-to-string "git config --global user.email") )
      js-doc-author (format "%s <%s>" (shell-command-to-string "git config --global user.name") js-doc-mail-address)
      js-doc-url nil
      js-doc-license nil)

(add-hook 'js2-mode-hook
          #'(lambda ()
              (evil-define-key 'normal js2-mode-map (kbd "M-s-/") 'js-doc-insert-function-doc)
              (evil-define-key 'normal js2-mode-map (kbd "M-s-÷") 'js-doc-insert-function-doc)
              (define-key js2-mode-map "@" 'js-doc-insert-tag)))

(require-package 'rjsx-mode)
(add-to-list 'auto-mode-alist '("\\.js$" . rjsx-mode))
(add-to-list 'auto-mode-alist '("\\.jsx$" . rjsx-mode))
(add-to-list 'auto-mode-alist '("\\.ts$" . rjsx-mode))

;; jsx缩进4
(setq sgml-basic-offset 4)

(require-package 'web-mode)
;; (add-to-list 'auto-mode-alist '("\\.js$" . web-mode))
;; (add-to-list 'auto-mode-alist '("\\.jsx$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

(defun my-web-mode-hook ()
  (setq web-mode-markup-indent-offset 4)
  (setq web-mode-code-indent-offset 4)
  (setq web-mode-attr-indent-offset 4))
(add-hook 'web-mode-hook  'my-web-mode-hook)

(require-package 'emmet-mode)
(add-hook 'web-mode-hook 'emmet-mode)
(add-hook 'rjsx-mode-hook 'emmet-mode)

(require-package 'prettier-js)
(add-hook 'js2-mode-hook 'prettier-js-mode)
(add-hook 'web-mode-hook 'prettier-js-mode)
(add-hook 'rjsx-mode-hook 'prettier-js-mode)
(setq prettier-js-args '(
                         "--trailing-comma" "all"
                         "--bracket-spacing" "false"
                         "--tab-width" "4"
                         "--print-width" "120"
                         ))
(defun enable-minor-mode (my-pair)
  "Enable minor mode if filename match the regexp.  MY-PAIR is a cons cell (regexp . minor-mode)."
  (if (buffer-file-name)
      (if (string-match (car my-pair) buffer-file-name)
          (funcall (cdr my-pair)))))
(add-hook 'rjsx-mode-hook #'(lambda ()
                             (enable-minor-mode
                              '("\\.js?\\'" . prettier-js-mode))))

;; (setq-default flycheck-disabled-checkers
;;               (append flycheck-disabled-checkers
;;                       '(javascript-jshint)))

;; (setq-default flycheck-disabled-checkers
;;               (append flycheck-disabled-checkers
;;                       '(json-jsonlist)))

;; (flycheck-add-mode 'javascript-eslint 'web-mode)
;; (flycheck-add-mode 'javascript-eslint 'js2-mode)

;; (defun custom-use-eslint-from-node-modules ()
;;   (let* ((root (locate-dominating-file
;;                 (or (buffer-file-name) default-directory)
;;                 "node_modules"))
;;          (eslint (and root
;;                       (expand-file-name "node_modules/eslint/bin/eslint.js"
;;                                         root))))
;;     (when (and eslint (file-executable-p eslint))
;;       (setq-local flycheck-javascript-eslint-executable eslint))))

;; (add-hook 'flycheck-mode-hook #'custom-use-eslint-from-node-modules)

;;   (evil-leader/set-key
;;     "jr" 'custom-browse-this-html-and-back
;;     "jw" 'custom-init-react-window)

;; (defun custom-init-react-window ()
;;   "Device emacs & firefox"
;;   (interactive)
;;   (shell-command (format "osascript %s" (expand-file-name "init/reactenv.scpt" user-emacs-directory))))


  ;; (defun custom-init-react-IDE ()
  ;;   "Init react IDE"
  ;;   (interactive)
  ;;   (let ((project-dir (directory-file-name ))))
  ;;   (when (= (string-to-int (shell-command-to-string "ps | grep \"react-scripts start\" | wc -l | tr -d \' \n\'")) 0)
  ;;     (shell-command "npm start"))
  ;;   )

;; (evil-leader/set-key
;;   "ja" 'custom-toggle-html-auto-refresh)

;; (defun custom-browse-this-html ()
;;   (interactive)
;;   (unless (process-status "httpd")
;;     (httpd-start))
;;   (let ((name (file-name-nondirectory (buffer-file-name))))
;;     (setq httpd-root (file-name-directory (buffer-file-name)))
;;     (shell-command (format "open -a Firefox http://127.0.0.1:%s/%s" httpd-port name))))

;; (defun custom-browse-this-html-and-back ()
;;   (interactive)
;;   "Browse this file and come back"
;;   (run-with-timer
;;    0.2 nil
;;    (lambda ()
;;      (select-frame-set-input-focus (selected-frame))))
;;   (custom-browse-this-html))

;; (defvar custom-html-auto-refresh-b nil "wheter html refresh browser when save")

;; (defun custom-save-hook-refresh-browser ()
;;   "Add refresh html to save hook."
;;   (let (current-frame (select-frame))
;;     (when (or (equal major-mode 'web-mode) (equal major-mode 'rjsx-mode))
;;       (custom-browse-this-html-and-back))))

;; (defun custom-toggle-html-auto-refresh ()
;;   "If you're using react, then you should disable this."
;;   (interactive)
;;   (setq custom-html-auto-refresh-b (not custom-html-auto-refresh-b))
;;   (if custom-html-auto-refresh-b
;;       (progn (add-hook 'after-save-hook 'custom-save-hook-refresh-browser)
;;              (message "Enable auto refresh"))
;;     (progn (remove-hook 'after-save-hook 'custom-save-hook-refresh-browser)
;;            (message "Disable auto refresh"))))

(provide 'init-js)
