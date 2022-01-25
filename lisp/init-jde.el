(autoload 'jde-mode "jde" "JDE mode" t)
(setq auto-mode-alist
      (append '(("\\.java\\'" . jde-mode)) auto-mode-alist))
(defun my-jde-bsh-run () ;; 进入jde自动启动beanshell，否则会在每次运行jde命令的时候再启动，比较慢。
  (save-excursion
    (jde-bsh-run)))
(add-hook 'jde-mode-hook 'my-jde-bsh-run)

(defun my-jde-import-organize ()
  (interactive)
  (jde-import-all)
  (jde-import-kill-extra-imports)
  (jde-import-organize)
)
(defun my-jde-compile-finish-update-xref (buf msg)
  (with-current-buffer buf
    (if (null (or (string-match ".*exited abnormally.*" msg)
		  (string-match ".*BUILD FAILED.*" (buffer-string))))
	;;no errors, make the compilation window go away in a few seconds
      ;;there were errors, so jump to the first error
      (jde-xref-make-xref-db))))
(defun my-jde-xref-list-uncalled-functions (strict)
  (interactive "P")
  (kill-buffer (get-buffer-create "Unreferenced Methods and Members"))
  (jde-xref-list-uncalled-functions strict)
)

(define-key java-mode-map [f7] 'jde-debug-step-into)
(define-key java-mode-map [f8] 'jde-debug-step-over)
(define-key java-mode-map (kbd "M-<f8>") 'jde-debug-step-out)
(define-key java-mode-map (kbd "C-S-b") 'jde-debug-toggle-breakpoint)
(define-key java-mode-map [C-f10] 'jde-debug)
;; (define-key java-mode-map (kbd "C-SPC") 'jde-complete)
;; (define-key java-mode-map (kbd "C-S-m") 'jde-import-all)
;; (define-key java-mode-map (kbd "C-S-o") 'my-jde-import-organize)
;; (define-key java-mode-map (kbd "C-S-s") 'jde-jdb-set)
;; (define-key java-mode-map (kbd "C-S-l") 'jde-jdb-locals)
;; (define-key java-mode-map (kbd "C-S-v") 'jde-jdb-print)
;; (define-key java-mode-map (kbd "C-S-d") 'jde-jdb-dump)
;; (define-key java-mode-map (kbd "C-S-u") 'jde-debug-up)
;; (define-key java-mode-map (kbd "C-S-g") 'jde-xref-display-call-tree)
;; (define-key java-mode-map (kbd "C-S-f") 'jde-xref-first-caller)
;; (define-key java-mode-map (kbd "C-S-n") 'jde-xref-next-caller)
;; (define-key java-mode-map (kbd "C-S-r") 'my-jde-xref-list-uncalled-functions)
;; (define-key java-mode-map [f2] 'jde-rename-class)
;; (define-key java-mode-map [f3] 'jde-open-class-at-point)
;; (define-key java-mode-map [S-f8] 'jde-debug-cont)
;; (define-key java-mode-map [C-f9] 'jde-build)
;; (define-key java-mode-map [C-f11] 'jde-run)

(provide 'init-jde)
