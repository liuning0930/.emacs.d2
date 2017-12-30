;; (require-package 'ycmd)
;; (add-hook 'c-mode-hook 'ycmd-mode)
;; (add-hook 'c++-mode-hook 'ycmd-mode)

;; (set-variable 'ycmd-server-command '("c" (file-truename "~/.emacs.d/elpa/ycmd-20171111.854/")))
;; (set-variable 'ycmd-server-command '("c++" (file-truename "~/.emacs.d/elpa/ycmd-20171111.854/")))

(require-package 'company-ycmd)
(require 'company-ycmd)
(company-ycmd-setup)
(add-to-list 'company-backends 'company-ycmd)

(require-package 'flycheck-ycmd)
(require 'flycheck-ycmd)
;; Make sure the flycheck cache sees the parse results
(add-hook 'ycmd-file-parse-result-hook 'flycheck-ycmd--cache-parse-results)

;; Add the ycmd checker to the list of available checkers
(add-to-list 'flycheck-checkers 'ycmd)

(require-package 'auto-complete-clang)
(require 'auto-complete-clang)
(setq ac-auto-start nil)
(setq ac-quick-help-delay 0.5)

(define-key ac-mode-map  [(control tab)] 'auto-complete)

(defun my-ac-config ()
  (setq-default ac-sources '(ac-source-abbrev ac-source-dictionary ac-source-words-in-same-mode-buffers))
  (add-hook 'emacs-lisp-mode-hook 'ac-emacs-lisp-mode-setup)
  ;; (add-hook 'c-mode-common-hook 'ac-cc-mode-setup)
  (add-hook 'ruby-mode-hook 'ac-ruby-mode-setup)
  (add-hook 'css-mode-hook 'ac-css-mode-setup)
  (add-hook 'auto-complete-mode-hook 'ac-common-setup)
  (global-auto-complete-mode t))
(defun my-ac-cc-mode-setup ()
  (setq ac-sources (append '(ac-source-clang ac-source-yasnippet) ac-sources)))
(add-hook 'c-mode-common-hook 'my-ac-cc-mode-setup)
(add-hook 'c-mode-hook 'my-ac-cc-mode-setup)
(add-hook 'c++-mode-common-hook 'my-ac-cc-mode-setup)
(add-hook 'c++-mode-hook 'my-ac-cc-mode-setup)
;; ac-source-gtags
(my-ac-config)

(setq ac-clang-flags 
      (mapcar (lambda (item)(concat "-I" item))
              (split-string
               "/usr/local/include
 /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include/c++/v1
 /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/clang/9.0.0/include
 /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include
 /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.13.sdk/usr/include
 /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.13.sdk/System/Library/Frameworks (framework directory)
 "
               )))


(provide 'init-ycmd)
