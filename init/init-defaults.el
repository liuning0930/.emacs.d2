;;brew安装的库会默认以/usr/local/emacs为基准，而相对应的el文件则保存在这里：
(let ((default-directory "/usr/local/share/emacs/site-lisp/"))
  (normal-top-level-add-subdirs-to-load-path))

;; Write backup files to own directory
(setq backup-directory-alist
      `(("." . ,(expand-file-name
                 (concat user-emacs-directory "backups")))))

;; Make backups of files, even when they're in version control
(setq vc-make-backup-files t)

;; not good choice
;; (setq make-backup-files nil)

;;保存文件的编辑位置。
;; (desktop-save-mode 1)

;; 隐藏行号 会导致org mode编辑代码卡顿
(global-linum-mode 0)

;; 暂时显示行号
(global-set-key [remap goto-line] 'goto-line-with-feedback)

(defun goto-line-with-feedback ()
  "Show line numbers temporarily, while prompting for the line number input"
  (interactive)
  (unwind-protect
      (progn
        (linum-mode 1)
        (goto-line (read-number "Goto line: ")))
    (linum-mode -1)))

;; title show full path
(setq frame-title-format
      '((:eval (if (buffer-file-name)
                   (abbreviate-file-name (buffer-file-name))
                 "%b"))))

;; 高亮当前行
(global-hl-line-mode 1)

;; 选中删除
(delete-selection-mode 1)

;; max size
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; 更改光标的样式
(setq-default cursor-type 'bar)

;; 关闭启动帮助画面
(setq inhibit-splash-screen 1)
(setq inhibit-splash-screen t)
(setq initial-scratch-message nil)
;; (setq initial-buffer-choice "~/")

;; 更改显示字体大小 16pt
;; http://stackoverflow.com/questions/294664/how-to-set-the-font-size-in-emacs
(set-face-attribute 'default nil :height 140)

(setq ring-bell-function 'ignore)

;; 更好的滚动
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1) ((control) . nil)))
(setq mouse-wheel-progressive-speed nil)

;; yes/no -> y/n
(fset 'yes-or-no-p 'y-or-n-p)

(setq scroll-preserve-screen-position t)

;; if use no simpleclip, then use isearch-yank-pop
(define-key isearch-mode-map (kbd "s-v") 'custom-isearch-yank-pop)

(defun custom-isearch-yank-pop ()
  "For paste in minibuffer isearch"
  (interactive)
  (deactivate-mark)
  (isearch-push-state)
  (isearch-yank-string (simpleclip-get-contents)))

(defun custom-isearch-with-region ()
  "Use region as the isearch text."
  (when mark-active
    (let ((region (filter-buffer-substring (region-beginning) (1+ (region-end)))))
      (deactivate-mark)
      (isearch-push-state)
      (isearch-yank-string region))))

(add-hook 'isearch-mode-hook 'custom-isearch-with-region)

(require-package 'highlight-parentheses)
(global-highlight-parentheses-mode)

(defun no-trailing-whitespace ()
  (setq show-trailing-whitespace nil))

(setq no-trailing-modes '(minibuffer-setup-hook
                          eww-mode-hook
                          ielm-mode-hook
                          gdb-mode-hook
                          help-mode-hook
                          artist-mode-hook
                          term-mode-hook
                          mu4e-view-mode-hook
                          mu4e-org-mode-hook
                          mu4e-main-mode-hook))
(dolist (element no-trailing-modes nil)
  (add-hook element 'no-trailing-whitespace))

(require-package 'better-defaults)
(require 'better-defaults)

;; make-term version
(defun fast-terminal ()
  "fastway to access terminal. Only open one."
  (interactive)
  (unless (get-buffer-window "*terminal*" 'visible)
    (unless (get-buffer "*terminal*")
      (make-term "terminal" (getenv "SHELL")))
    (split-window-sensibly)
    (other-window 1)
    (set-buffer "*terminal*")
    (term-mode)
    (term-char-mode)
    (switch-to-buffer "*terminal*")
    (and default-directory (term-send-raw-string (format "cd %s\n" default-directory)))
    (goto-char (point-max))
    ))

;; auto delete window when process exit
(add-hook 'term-exec-hook (lambda ()
                            (let* ((buff (current-buffer))
                                   (proc (get-buffer-process buff)))

                                                                 (lexical-let ((buff buff))
                                (set-process-sentinel proc (lambda (process event)
                                                             (if (string= event "finished\n")
                                                                 (kill-buffer-and-window))))))))

(global-set-key (kbd "<f12>") 'fast-terminal)
(add-hook 'term-mode-hook '(lambda () (evil-define-key 'normal term-raw-map (kbd "q") '(lambda () (interactive) (other-window -1) (delete-window (get-buffer-window "*terminal*"))))))

(defun fast-terminal-eshell ()
  "Opens up a new shell in the directory associated with the current buffer's file."
  (interactive)
  (let* ((parent (if (buffer-file-name)
                     (file-name-directory (buffer-file-name))
                   default-directory))
         (name (car (last (split-string parent "/" t)))))
    (split-window-vertically)
    (other-window 1)
    (eshell "new")
    (rename-buffer (concat "*eshell: " name "*"))

    (insert (concat "ls"))
    (eshell-send-input)))

(defun quit-eshell-window (&optional window)
  "Remove WINDOW from the display.  Default is `selected-window'.
If WINDOW is the only one in its frame, then `delete-frame' too."
  (interactive)
  (save-current-buffer
    (setq window (or window (selected-window)))
    (select-window window)
    (kill-buffer)
    (if (one-window-p t)
        (delete-frame)
      (delete-window (selected-window)))))

;; (global-set-key (kbd "<f12>") 'fast-terminal-eshell)
;; (add-hook 'eshell-mode-hook '(lambda () (evil-define-key 'normal eshell-mode-map (kbd "q") 'quit-eshell-window)))

;; help
(define-key 'help-command (kbd "C-k") 'find-function-on-key)
(define-key 'help-command (kbd "C-v") 'find-variable)
(define-key 'help-command (kbd "C-f") 'find-function)

;; replace eval command from alt-x
(global-set-key (kbd "C-x C-m") 'execute-extended-command)

(defun clean-message-buffer ()
  "Fast way to clean message buffer's output"
  (interactive)
  (let ((messagebuffer (get-buffer "*Messages*")))
    (when messagebuffer
      (kill-buffer "*Messages*"))
    (view-echo-area-messages)))

(global-set-key (kbd "C-c m c") 'clean-message-buffer)

(defun custom-writeCurrentDirToCahceFile ()
  (with-temp-file  (concat user-emacs-directory  "currentDir") (insert (expand-file-name (directory-file-name default-directory)))))
(add-hook 'focus-out-hook 'custom-writeCurrentDirToCahceFile)

(require-package 'switch-window)
(global-set-key (kbd "C-x o") 'switch-window)
(global-set-key (kbd "C-x 1") 'switch-window-then-maximize)
(global-set-key (kbd "C-x 2") 'switch-window-then-split-below)
(global-set-key (kbd "C-x 3") 'switch-window-then-split-right)
(global-set-key (kbd "C-x 0") 'switch-window-then-delete)


(require-package 'indent-guide)
(indent-guide-global-mode)

(require-package 'popwin)
(require 'popwin)
(popwin-mode t)

; display function ,symbols menu list
(require-package 'imenu-list)
(global-set-key (kbd "C-'") #'imenu-list-smart-toggle)
(setq imenu-list-focus-after-activation t)
(setq imenu-list-auto-resize t)
(setq imenu-list-after-jump-hook nil)
(setq imenu-list-after-jump-hook nil)
(add-hook 'imenu-list-after-jump-hook #'recenter-top-bottom)

(require-package 'projectile)
(projectile-mode t)

(require-package 'company)
(add-hook 'after-init-hook 'global-company-mode)

(require-package 'ace-pinyin)
;;(ace-pinyin-global)

(provide 'init-defaults)
