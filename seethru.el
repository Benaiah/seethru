;;; seethru.el --- Easily change Emacs' transparency
;; Copyright (C) 2014 Benaiah Mischenko

;; Author: Benaiah Mischenko <benaiah@mischenko.com>
;; Maintainer: Benaiah Mischenko <benaiah@mischenko.com>
;; URL: http://github.com/benaiah/seethru
;; Created: 11th November 2014
;; Version: 0.1
;; Keywords: lisp, tools, alpha, transparency
;; Package-Requires: ((shadchen "1.4"))

;;; Commentary:
;; Seethru: Easily change Emacs' frame transparency
;;
;; The use of seethru is very simple. To set the transparency to an
;; absolute value:
;;
;;     (seethru 55)
;;
;; To set the transparency relative to its current value:
;;
;;     (seethru-relative -10)
;;
;; This is usually used to bind to a key, like so:
;;
;;     (global-set-key (kbd "<M-wheel-up>")
;;                     (lambda ()
;;                       (seethru-relative -10)))
;;
;; To set up recommended keybindings, which are `C-c 8' to reduce
;; transparency and `C-c 9' to increase it, as well as shifted
;; keybinds which do the same, but slower:
;;
;;     (seethru-recommended-keybinds)
;;
;; To set up mouse bindings, which are wheel-up to increase
;; transparency and wheel-down to decrease it:
;;
;;     (seethru-mouse-bindings)
;;
;; You can optionally change the modifier used by either
;; `seethru-recommended-keybinds' or `seethru-mouse-bindings' simply
;; by passing an argument in, for example:
;;
;;     (seethru-recommended-keybinds "C-x") ;; "C-x 8" and "C-x 9"
;;     (seethru-mouse-bindings "C") ;; hold control while wheeling
;;                                  ;; mouse to change transparency

;;; Code:

(require 'shadchen)

(defun seethru (value)
  "Sets the transparency of the currently selected Emacs
frame (0-100, where 0 is transparent and 100 is opaque)"
  (interactive "nTransparency")
  (set-frame-parameter (selected-frame) 'alpha value))

(defun seethru-relative (value)
  (let* ((current-transparency (frame-parameter (selected-frame) 'alpha))
         (summed-transparency (+ current-transparency value)))
    (transparency (match summed-transparency
                    ((? (lambda (x) (< x 0)) x) 0)
                    ((? (lambda (x) (> x 100)) x) 100)
                    (val val)))))

(defun seethru-recommended-keybinds (&optional prefix)
  (let ((pre (if (not prefix) "C-c" prefix)))
    (global-set-key (kbd (concat pre " 8"))
                    (lambda () (interactive) (seethru-relative 10)))
    (global-set-key (kbd (concat pre " *"))
                    (lambda () (interactive) (seethru-relative 5)))
    (global-set-key (kbd (concat pre " 9"))
                    (lambda () (interactive) (seethru-relative-10)))
    (global-set-key (kbd (concat pre " ("))
                    (lambda () (interactive) (seethru-relative -5)))))

(defun seethru-mouse-bindings (&optional prefix)
  (let ((pre (if (not prefix) "M" prefix)))
    (global-set-key (kbd (concat "<" pre "-wheel-down>"))
                    (lambda () (interactive) (seethru-relative 1)))
    (global-set-key (kbd (concat "<" pre "-wheel-up>"))
                    (lambda () (interactive) (seethru-relative -1)))))
