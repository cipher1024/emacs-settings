
;; You need to modify the following two lines:
;; (setq lean-rootdir "~/Project/Lean-PR-next/lean")
;; (setq lean-emacs-path "~/Project/Lean-PR-next/lean/src/emacs")
(setq lean-rootdir "~/Lean/lean")
(setq lean-emacs-path "~/Lean/lean/src/emacs")

(setq lean-mode-required-packages '(company dash dash-functional f
                               flycheck let-alist s seq))

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize)
(let ((need-to-refresh t))
  (dolist (p lean-mode-required-packages)
    (when (not (package-installed-p p))
      (when need-to-refresh
        (package-refresh-contents)
        (setq need-to-refresh nil))
      (package-install p))))

(setq load-path (cons lean-emacs-path load-path))

(require 'lean-mode)

(require 'package)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-archives
   (quote
    (("gnu" . "http://elpa.gnu.org/packages/")
     ("melpa-stable" . "http://stable.melpa.org/packages/")))))
(package-initialize)



;; (desktop-save-mode 10)

(add-hook 'before-save-hook 'delete-trailing-whitespace)

(find-file "~/.emacs")

(defun lean-project (path lean-path &rest sources)
  "declare a lean project with its root path, lib path and some sources"
  (list path (list lean-path) sources))

(defun lean-lib-project (path &rest sources)
  "declare a lean library project with only a root path"
  (list path nil sources))

;; (defvar current-project nil)

;; (defun close-current-project ()
;;   "foo bar"
;;   (if (not (null current-project))
;;       (progn (current-project)
;; 	     (set current-project nil))))

;; (set current-project
;;      (lambda ()
;;        (progn (delete-window right)
;; 	      (delete-window below))))

(defun setup-lean-displays ()
  "documentation"
  (progn
    (split-window-right)
    (lean-toggle-next-error)
    (next-multiframe-window)
    (split-window-below)
    (lean-toggle-show-goal)
    (previous-multiframe-window)
    ))

(defun lean-select-project (prj)
  "bar"
  (let* ( (path (nth 0 prj))
	  (home-path (concat (getenv "HOME") path))
	  (lean-path (nth 1 prj))
	  (source (nth 2 prj))  )
    (progn
      (setq current-project home-path)
      (setenv "LEAN_PATH" (mapconcat 'identity (cons home-path lean-path) ":"))
      (mapc #'(lambda (x) (find-file (concat home-path x))) source)
      (lean-server-restart)
      )))

; (insert "hello")

(setq lean-root
  (lean-lib-project
   "/Lean/lean/library"
   "/init/data/nat/lemmas.lean"))
(setq lean-pr
  (lean-lib-project
   "/Project/Lean-PR/lean/library"
   "/data/bitvec.lean"))
(setq lean-pr-next
  (lean-lib-project
   "/Project/Lean-PR-next/lean/library"
   "/init/data/nat/lemmas.lean"))
(setq aim-pr
  (lean-project
   "/Project/AIM/AIM-PR/aim-specification/lean"
   "/usr/local/lib/lean/library"
   "/aim/tlv.lean"
   "/aim/proofs/tlv.lean"
   "/aim/ksi.lean"
   "/aim/proofs/ksi.lean"))
(setq contrib-pr
  (lean-project
   "/Project/AIM/AIM-PR/aim-specification/lean"
   "/usr/local/lib/lean/library"
   "/contrib.lean"))
(setq unit-b
  (lean-project
   "/Project/backed-up/Simon/Lean/project"
   "/usr/local/lib/lean/library"
   "/unity/logic.lean"
   "/unity/countable.lean"))
(setq aim-sha2-type-arith
  (lean-project
   "/Project/AIM/AIM-sha2-type-arith/aim-specification/lean"
   "/usr/local/lib/lean/library"
   "/aim/bitvec.lean"))

(setup-lean-displays)
;; ; (insert "world")
;; ;; '(
;; ;;   (lean-select-project aim-pr)
;; ;;   (lean-select-project unit-b)
;; ;;   (lean-select-project lean-root)
;; ;;   (lean-select-project lean-pr-next)
;; ;;   (lean-select-project lean-pr)
;; ;;   (lean-select-project aim-sha2-type-arith)
;; ;; )

;; ; (desktop-save-mode 1)

;; ; (lean-select-project unit-b)
;; (lean-select-project contrib-pr)
;; ; (lean-select-project lean-root)
;; ; (lean-select-project lean-pr-next)
;; ; (lean-select-project lean-pr)
;; ; (lean-select-project aim-sha2-type-arith)

;; ; (insert "hello world")
