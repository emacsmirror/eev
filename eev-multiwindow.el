;; eev-multiwindow.el - functions to create multi-window setups

;; Copyright (C) 2012,2013 Free Software Foundation, Inc.
;;
;; This file is (not yet?) part of GNU eev.
;;
;; GNU eev is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; GNU eev is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.
;;
;; Author:     Eduardo Ochs <eduardoochs@gmail.com>
;; Maintainer: Eduardo Ochs <eduardoochs@gmail.com>
;; Version:    2013aug24
;; Keywords:   e-scripts
;;
;; Latest version: <http://angg.twu.net/eev-current/eev-multiwindow.el>
;;       htmlized: <http://angg.twu.net/eev-current/eev-multiwindow.el.html>
;;       See also: <http://angg.twu.net/eev-current/eev-readme.el.html>
;;                 <http://angg.twu.net/eev-intros/find-eev-intro.html>
;;                                                (find-eev-intro)

;;; Commentary:


(defun find-wset-1 () (delete-other-windows))
(defun find-wset-2 () (split-window-vertically))
(defun find-wset-3 () (split-window-horizontally))
(defun find-wset-s () (split-window-sensibly (selected-window)))
(defun find-wset-o () (other-window 1))
(defun find-wset-+ () (balance-windows))
(defun find-wset-_ () (eval (car sexps)) (setq sexps (cdr sexps)))
(defun find-wset-\ ())			; allow whitespace

(defun find-wset (chars &rest sexps)
  "Create a multi-window setting according to CHARS and SEXPS.
A detailed explanation is here: (find-multiwindow-intro)

Here is a list of the standard characters that can be used in CHARS:
  1:  `delete-other-windows'       (C-x C-1)
  2:  `split-window-vertically'    (C-x C-2)
  3:  `split-window-horizontally'  (C-x C-3)
  s:  `split-window-sensibly'
  o:  `other-window'               (C-x o)
  +:  `balance-windows'            (C-x +)
  _:  execute the next sexp in SEXPS.

To add support for a new character, say `C', just define
a function `find-wset-C'."
  (if (not (equal chars ""))
      (let ((c     (substring chars 0 1))
	    (chars (substring chars 1)))
	(funcall (ee-intern "find-wset-%s" c))
	(apply 'find-wset chars sexps))))





;;;                  _ _       _       _                _        
;;;   ___  ___ _ __ (_) |_ ___| |__   | |__   __ _  ___| | _____ 
;;;  / _ \/ _ \ '_ \| | __/ __| '_ \  | '_ \ / _` |/ __| |/ / __|
;;; |  __/  __/ |_) | | || (__| | | | | | | | (_| | (__|   <\__ \
;;;  \___|\___| .__/|_|\__\___|_| |_| |_| |_|\__,_|\___|_|\_\___/
;;;           |_|                                                

(defun ee-here (code)
  "Example: (ee-here '(eepitch-xxx)) opens the target of (eepitch-xxx) here.
\"Here\" means \"in the current window, without disturbing the
current window configuration\". Normal calls to `eepitch-xxx'
functions split the screen and open the target buffer in another
window; by wrapping them in an `(ee-here ...)' we can bypass
that. This is mainly for `find-wset'."
  (let (result)
    (find-ebuffer
     (save-window-excursion
       (setq result (eval code))
       eepitch-buffer-name))
    result))

(defun ee-here-reset (code)
  "Like `ee-here', but also does an `eepitch-kill'."
  (let (result)
    (find-ebuffer
     (save-window-excursion
       (eval code)
       (eepitch-kill)
       (setq result (eval code))
       eepitch-buffer-name))
    result))

(defun find-wset-= () (ee-here       (car sexps)) (setq sexps (cdr sexps)))
(defun find-wset-! () (ee-here-reset (car sexps)) (setq sexps (cdr sexps)))
(defun find-wset-O () (other-window -1))

;; Mnemonic: "e" and "E" are both to prepare eepitch windows;
;; "E" is more aggressive. See:
(defun find-wset-e () (ee-here       (car sexps)) (setq sexps (cdr sexps)))
(defun find-wset-E () (ee-here-reset (car sexps)) (setq sexps (cdr sexps)))



;; (find-multiwindow-intro)
;; Temporary hacks
(defun find-2a (a b)   (find-wset "13_o_o" a b))
(defun find-2b (a b)   (find-wset "13_o_"  a b))
(defun find-3a (a b c) (find-wset "13_o2_o_o"  a b c))
(defun find-3b (a b c) (find-wset "13_o2_o_oo" a b c))
(defun find-3c (a b c) (find-wset "13_o2_o_"   a b c))

(defun find-3ee (b c) (find-wset "13o2=o=o" b c))
(defun find-3EE (b c) (find-wset "13o2!o!o" b c))




(provide 'eev-multiwindow)





;; Local Variables:
;; coding:            raw-text-unix
;; ee-anchor-format:  "defun %s "
;; no-byte-compile:   t
;; End:
