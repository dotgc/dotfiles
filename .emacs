(global-set-key [delete] 'delete-char)
(global-set-key "\C-h" 'delete-char)
(global-set-key [kp-delete] 'delete-char)

(setq require-final-newline t)
(setq indent-tabs-mode nil)
(setq tab-width 4)
(setq mustache-basic-offset 4)
(setq sgml-basic-offset 4) ;; For jinja


(defun no-tabs-hook ()
  (setq c-basic-offset 4)
  (setq tab-width 4)
  (setq indent-tabs-mode nil))


(add-hook 'mustache-mode-hook 'no-tabs-hook)
(add-hook 'python-mode-hook 'no-tabs-hook)
(add-hook 'web-mode-hook 'no-tabs-hook)
(add-hook 'java-mode-hook 'no-tabs-hook)
(add-hook 'web-mode-user-hook 'no-tabs-hook)
;;(add-hook 'javascript-mode-hook 'js2-mode)
(add-hook 'css-mode-hook 'no-tabs-hook)
(add-hook 'thrift-mode-hook 'no-tabs-hook)
;;(add-hook 'js2-mode-hook 'no-tabs-hook)


(add-hook 'before-save-hook 'delete-trailing-whitespace)
(add-hook 'before-save-hook 'gofmt-before-save)


;; explicit mappings to for special keys to overcome terminfo problems
(define-key esc-map "\C-h" 'backward-kill-word)
(define-key esc-map "[1~" 'beginning-of-buffer)
(define-key esc-map "[7~" 'beginning-of-buffer)
(define-key esc-map "[4~" 'end-of-buffer)
(define-key esc-map "[8~" 'end-of-buffer)
(define-key esc-map "[1;4D" 'backward-word)
(define-key esc-map "[1;4C" 'forward-word)

(defun my-shell ()
  (interactive)
  (if (= (count-windows) 1)
      (progn (split-window)))
  (select-window (next-window))
  (shell))

(global-set-key (kbd "C-c r") (lambda ()
				(interactive)
                                (revert-buffer t t t)
                                (message "buffer is reverted")))

(defun current-line-number ()
  "Returns the current line number, such that goto-line <n> would
go to the current line."
  (save-excursion
    (let ((line 1)
          (limit (point)))
      (goto-char 1)
      (while (search-forward "\n" limit t 40)
        (setq line (+ line 40)))
      (while (search-forward "\n" limit t 1)
        (setq line (+ line 1)))
      line)))

(defun buffer-info ()
  "Display information about current buffer."
  (interactive)
  (let* ((this-line (current-line-number))
         (total-lines (+ this-line (count-lines (point) (buffer-size))))
         (filename (or (buffer-file-name) (buffer-name))))
    (message (format "\"%s\" column %d, line %s/%s, char %d/%d (%d pct)."
                     (file-name-nondirectory filename)

                     (current-column)
                     this-line (1- total-lines)
                     (1- (point)) (buffer-size)
                     (/ (* 100.0 (1- (point))) (buffer-size))))))


(defun write-modified-buffers (arg)
  (interactive "P")
  (save-some-buffers (not arg)))

(defun end-of-window ()
  "Move point to the end of the window."
  (interactive)
  (goto-char (- (window-end) 1)))

(defun beginning-of-window ()
  "Move point to the beginning of the window."
  (interactive)
  (goto-char (window-start)))

(defun my-split-window ()
  (interactive)
  (split-window)
  (select-window (next-window)))

(defun my-scroll-forward (arg)
  "Scrolls forward by 1 or ARG lines."
  (interactive "p")
  (scroll-up (if (= arg 0) 1 arg)))

(defun my-scroll-backward (arg)
  "Scrolls forward by 1 or ARG lines."
  (interactive "p")
  (scroll-down (if (= arg 0) 1 arg)))

(defun my-next-window ()
  "moves to the window above the current one"
   (interactive)
   (other-window 1))

(defun my-previous-window ()
  "moves to the window above the current one"
   (interactive)
   (other-window -1))

(defun cdf ()
  "switches to *shell* and cd's to the current buffer's file dir."
  (interactive)
  (let ((shell-window (get-buffer-window "*shell*"))
        (fn (buffer-file-name)))
    (if shell-window
        (select-window shell-window)
      (my-shell))
    (switch-to-buffer "*shell*")
    (insert "cd " fn)
    (search-backward "/")
    (kill-line)
    (comint-send-input)))

(setq default-major-mode 'text-mode)
(setq-default truncate-lines nil)

;;replace occurences of a with b in path
(defun replace-char (path a b)
  (progn
    (while (string-match a path)
      (setq path (replace-match b t t path)))
    path))

;;Some shell stuff

(define-key ctl-x-map "!" 'shell-command)

(defun nuke-shell-buffer ()
  "clears the whole buffer without confirmation"
  (interactive)
  (delete-region (point-min) (point-max)))

(defun get-defaulted-arg-value (arg default)
  (if (consp arg)
      (car arg)
    (if (null arg)
        default
      arg)))

(defun shift-region-left (arg)
  (interactive "P")
  (let ((m (mark)) (p (point)) tmp)
    (if (< p m) (progn (setq tmp p) (setq p m) (setq m tmp)))
    (indent-rigidly m p (- (get-defaulted-arg-value arg 4)))))

(defun shift-region-right (arg)
  (interactive "P")
  (let ((m (mark)) (p (point)) tmp)
    (if (< p m) (progn (setq tmp p) (setq p m) (setq m tmp)))
    (indent-rigidly m p (get-defaulted-arg-value arg 4))))

(defun filter-region (&optional command)
  "Filter region through shell command."
  (interactive)
  (let* ((command (or command (read-input "Filter command: "))))
    (shell-command-on-region (point) (mark) command t)))

(defun replace-in-region-regexp (&optional old new)
  "Replace REGEXP with TO-STRING in region."
  (interactive)
  (let* ((old (or old (read-input "Replace regexp: ")))
         (new (or new (read-input (concat "Replace regexp: " old " with: ")))))
    (narrow-to-region (point) (mark))
    (beginning-of-buffer)
    (replace-regexp old new)
    (widen)))


;; MISC
(defvar *my-kill-query* (lambda () (yes-or-no-p "Really kill Emacs? ")))

(if (not (memq *my-kill-query* kill-emacs-query-functions))
    (setq kill-emacs-query-functions (cons *my-kill-query* kill-emacs-query-functions)))

(defun get-empty-buffer (name)
  (let ((b (get-buffer-create name)))
    (save-excursion
      (set-buffer b)
      (delete-region (point-min) (point-max)))
    b))

(defun save-position ()
  (cons (current-line-number) (current-column)))

(defun restore-position (state)
  (goto-line (car state))
  (move-to-column (cdr state)))

(put 'downcase-region 'disabled nil)
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(font-lock-builtin-face ((((class color) (min-colors 8)) (:foreground "orange" :weight bold))))
 '(font-lock-function-name-face ((((class color) (min-colors 8)) (:foreground "orange" :weight bold)))))
  ;; If there is more than one, they won't work right.

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(js2-auto-indent-p t)
 '(js2-cleanup-whitespace t)
 '(js2-enter-indents-newline t)
 '(js2-indent-on-enter-key t)
 )

(defun py-compile()
  (compile (concat "python " (buffer-name))))

(defun get-todos ()
  (interactive)
  (multi-occur-in-matching-buffers ".*" "TODO:"))

(defun backward-kill-word-or-region ()
  "do backwards kill word or kill-region depending on whether there is an active region"
  (interactive)
  (if (and transient-mark-mode mark-active)
      (kill-region (region-beginning) (region-end))
    (backward-kill-word 1)))

(global-set-key (kbd "C-w") 'backward-kill-word-or-region)

;; load js2 mode when javascript mode loads
(add-hook 'javascript-mode-hook (lambda ()
                                  (js2-mode)))

;; make sure we get no tabs in js2
(setq js2-mode-hook
      '(lambda () (progn
                    (set-variable 'indent-tabs-mode nil))))


;; python linting helpers
(defun my-py-lint ()
  "execute pyflakes on the current buffer"
  (interactive)
  (compile (concat "pyflakes " (buffer-file-name))))

(defun my-py-breaking ()
  "execute pybreaking on the current buffer"
  (interactive)
  (compile (concat "pybreaking.py " (buffer-file-name))))

(add-hook 'python-mode-hook
          '(lambda ()
             (define-key python-mode-map (kbd "C-c p")
                         'my-py-lint)))

(add-hook 'python-mode-hook
          '(lambda ()
             (define-key python-mode-map (kbd "C-c P")
                         'my-py-breaking)))


;; (add-to-list 'load-path "~/.emacs.d/emacs-for-python/") ;; tell where to load the various files
;; (require 'epy-setup)      ;; It will setup other loads, it is required!
;; (require 'epy-python)     ;; If you want the python facilities [optional]
;; (require 'epy-completion) ;; If you want the autocompletion settings [optional]
;; (require 'epy-editing)    ;; For configurations related to editing [optional]
;; (require 'epy-bindings)   ;; For my suggested keybindings [optional]
;; (require 'epy-nose)       ;; For nose integration
;; (epy-setup-ipython)
(put 'upcase-region 'disabled nil)

(package-initialize)
(elpy-enable)

(defun revert-all-buffers ()
    "Refreshes all open buffers from their respective files."
    (interactive)
    (dolist (buf (buffer-list))
      (with-current-buffer buf
        (when (and (buffer-file-name) (file-exists-p (buffer-file-name)) (not (buffer-modified-p)))
          (revert-buffer t t t) )))
    (message "Refreshed open files.") )
