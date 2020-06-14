;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Tim von Oldenburg"
      user-mail-address "tim@tvooo.de")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 14))

(setq doom-font (font-spec :family "InputMonoNarrow" :size 21)
      doom-variable-pitch-font (font-spec :family "InputMonoNarrow" :height 120)
      doom-unicode-font (font-spec :family "all-the-icons")
      doom-big-font (font-spec :family "InputMonoNarrow" :size 28))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'doom-one)
(require 'eink-theme "~/.timacs/eink-theme")
(load-theme 'eink t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type nil)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.

(setq tim/org-agenda-directory "~/org/")
(setq org-inbox-file "~/org/inbox.org")
(setq org-journal-dir "~/org/journal/")
(setq org-roam-directory tim/org-agenda-directory)
(setq deft-directory tim/org-agenda-directory)
(setq deft-recursive t)

(setq initial-buffer-choice "~/org/inbox.org")

(after! org (setq org-indent-mode t
                  org-startup-truncated nil
                  org-ellipsis "  "))

;; Tags
;; Don't right-align tags in headlines
(after! org (setq org-tags-column 0
                  org-tags-exclude-from-inheritance '("project", "@project")
                  org-tag-alist '((:startgroup . nil)
                      ("@office" . ?o) ("@home" . ?h)
                      (:endgroup . nil)
                      (:startgroup . nil)
                      ("@5mins" . ?5) ("@30mins" . ?3) ("@1hr" . ?1)
                      (:endgroup . nil)
                      ("@research" . ?R) ("@read" . ?r) ("@buy" . ?b) ("@dread" . ?d))
                  org-stuck-projects
                        '("+project/-MAYBE-DONE" ("NEXT" "TODO") ("@buy")
                        "\\<IGNORE\\>")
                        ))

(load-library "find-lisp")
(after! org (setq org-agenda-files
                      (find-lisp-find-files tim/org-agenda-directory "\.org$")))

(after! org
;; Hide all tags from the agenda
  (setq org-agenda-hide-tags-regexp ".*")
  ;; Capture templates
  (setq org-capture-templates
             '(("t" "Task" entry
                (file org-inbox-file)
"* TODO %? ")

            ("n" "Note" entry
                (file org-inbox-file)
"* %? ")

            ("l" "TIL" entry
                (file+olp "~/org/til.org" "Today I Learned")
"* %? ")

            ("b" "Book" entry
                (file+olp "~/org/media.org" "Books" "Backlog")
"* %? ")

            ("m" "Morning pages" entry
                (file+olp+datetree "~/org/journal/morningpages.org" "Morning pages")
                (file "~/org/templates/morningpages.template.org")
                 :tree-type week)))


;; When I’m starting an Org capture template I’d like to begin in insert mode. I’m opening it up in order to start typing something, so this skips a step.
   (add-hook 'org-capture-mode-hook 'evil-insert-state)

  
   

   ;; That will put auto-saving all open org files on a timer. Performing changes to buffers from the org agenda overview, for example, doesn’t mark the buffer as needing to auto-save, as far as I understand. So this setting helps to auto-save all org buffers regularly.
   (add-hook 'auto-save-hook 'org-save-all-org-buffers)

   (global-auto-revert-mode t)

   
   


    (global-set-key (kbd "C-S-s-M-p") 'org-roam-find-file)
    (global-set-key (kbd "C-S-s-M-a") 'org-agenda-list)
    (global-set-key (kbd "C-S-s-M-c") 'org-capture)
    ;; (global-set-key (kbd "s-b") 'helm-mini)
;;     (defun ask-user-about-lock (file other-user)
;;   "A value of t says to grab the lock on the file."
;;    t)
;;     (server-start)

;;     (find-file "~/org/inbox.org")
  
  )

(after! org (setq org-habit-show-habits t
                  ;; Make sure calendar views start the week on Monday
org-agenda-start-on-weekday 1
calendar-week-start-day 1))

(org-super-agenda-mode t)

(setq org-agenda-block-separator nil
      org-agenda-compact-blocks t)


(setq org-agenda-custom-commands
      '(("o" "Overview"
          (
           (todo "" ((org-agenda-overriding-header "Active projects")
                     (org-super-agenda-groups
                      '((:name none  ; Disable super group header
                               :tag ("@project" "project")
                               )
                        (:discard (:anything t))))))
           (todo "" ((org-agenda-overriding-header "Currently reading")
                     (org-super-agenda-groups
                      '((:name none  ; Disable super group header
                               :todo "READING")
                        (:discard (:anything t))))))
            (todo "" ((org-agenda-overriding-header "Paused reading")
                     (org-super-agenda-groups
                      '((:name none  ; Disable super group header
                               :todo "PAUSED")
                        (:discard (:anything t))))))
         
                        
                        
                        ))))

(setq org-super-agenda-groups
'((:name "Today"
                  :time-grid t
                  :tag ("NEXT" "outbox"))
           (:name "Important"
                  :priority "A")
           (:name "Dreading"
                  :tag "@dread")
           (:name "Habits"
                  :habit)
           (:name "Quick Picks"
                  :effort< "0:30"
                  :tag "@5mins")
           (:priority<= "B"
                        :scheduled future
                        :order 1)))


(setq emojify-display-style "unicode")
(setq emojify-emoji-set "twemoji-v2-22")
(global-emojify-mode t)


(after! org (set-popup-rule! "^Capture.*\\.org$" :side 'right :size .50 :select t :vslot 2 :ttl 3))
;; (after! org (set-popup-rule! "Dictionary" :side 'bottom :size .30 :select t :vslot 3 :ttl 3))
(after! org (set-popup-rule! "*helm*" :side 'bottom :size .30 :select t :vslot 5 :ttl 3))
;; (after! org (set-popup-rule! "*eww*" :side 'right :size .30 :slect t :vslot 5 :ttl 3))
;; (after! org (set-popup-rule! "*deadgrep" :side 'bottom :height .40 :select t :vslot 4 :ttl 3))
;; (after! org (set-popup-rule! "\\Swiper" :side 'bottom :size .30 :select t :vslot 4 :ttl 3))
;; (after! org (set-popup-rule! "*Ledger Report*" :side 'right :size .30 :select t :vslot 4 :ttl 3))
;; (after! org (set-popup-rule! "*xwidget" :side 'right :size .50 :select t :vslot 5 :ttl 3))
(after! org (set-popup-rule! "*Org Agenda*" :side 'right :size .40 :select t :vslot 2 :ttl 3))
;; (after! org (set-popup-rule! "*Org ql" :side 'right :size .50 :select t :vslot 2 :ttl 3))


(plist-put +popup-defaults :modeline t)

(setq org-refile-targets (quote ((nil :maxlevel . 9)
                                 (org-agenda-files :maxlevel . 9))))

;;(setq tim/todo-project '(sequence "PLANNED(p)" "ACTIVE(a)" "|" "COMPLETED(c)"))
;;(setq tim/todo-default '(sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)"))
;;(setq tim/todo-book '(sequence "TOREAD(t)" "READING(r)" "PAUSED(p)" "|" "FINISHED(f)"))

;;(after! org (setq org-todo-keywords '(tim/todo-default tim/todo-project tim/todo-book)))
;;(setq org-todo-keywords '(tim/todo-default tim/todo-project tim/todo-book))



(set-face-attribute 'org-todo nil
                    :height 0.8
                    :weight 'semi-bold
                    :inverse-video t
                    :box '(:line-width 2 
                           :color "black" 
                           :style nil)
                    )
(set-face-attribute 'org-done nil
                    :height 0.8
                    :weight 'semi-bold
                    )

(set-face-attribute 'org-tag nil
                    :foreground "purple"
                    :height 0.8
                    :weight 'semi-bold
                    )

;; (let ((fg "#111111")
;;       (fg-table "#222291")
;;       (bg "#fffff8")
;;       (bg-light "#ddddd8")
;;       (fg-light "#ddddd8")
;;       (bg-highlight "#FFF1AA")
;;       (bg-highlight-2 "LightCyan")
;;       (bg-highlight-3 "LightGreen"))

(setq green "#e9ffe9")
(setq yell "#fff1aa")

 (set-face-attribute 'org-habit-alert-face nil :background yell)
   (set-face-attribute 'org-habit-alert-future-face nil :background "#fff1aa")
   (set-face-attribute 'org-habit-clear-face nil :background "blue")
   (set-face-attribute 'org-habit-clear-future-face nil :background "blue")
   (set-face-attribute 'org-habit-overdue-face nil :background "red")
   (set-face-attribute 'org-habit-overdue-future-face nil :background "red")
   (set-face-attribute 'org-habit-ready-face nil :background green)
   (set-face-attribute 'org-habit-ready-future-face nil :background green)

;; (font-lock-add-keywords 'org-mode
 ;; '(("^.*:project:.*$" . font-lock-keyword-face)))

(setq org-todo-keywords
      '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
        (sequence "PLANNED(p)" "ACTIVE(a)" "|" "COMPLETED(c)")
        (sequence "TOREAD(t)" "READING(r)" "PAUSED(p)" "|" "FINISHED(f)")))


(setq doom-leader-key ","
  doom-localleader-key ", m")

(use-package! org-roam
  :commands (org-roam-insert org-roam-find-file org-roam-switch-to-buffer org-roam)
  :hook
  (after-init . org-roam-mode)
  :init
  (map! :leader
        :prefix "n"
        :desc "org-roam" "l" #'org-roam
        :desc "org-roam-insert" "i" #'org-roam-insert
        :desc "org-roam-switch-to-buffer" "b" #'org-roam-switch-to-buffer
        :desc "org-roam-find-file" "f" #'org-roam-find-file
        :desc "org-roam-show-graph" "g" #'org-roam-show-graph
        :desc "org-roam-insert" "i" #'org-roam-insert
        :desc "org-roam-capture" "c" #'org-roam-capture)

  :config
  (require 'org-roam-protocol)
    (setq org-roam-graph-executable "/usr/local/bin/dot")
    (setq org-roam-graph-viewer "open")
    (setq org-roam-capture-templates
'(("d" "default" plain (function org-roam--capture-get-point)
           "%?"
           :file-name "${slug}"
           :head "#+TITLE: ${title}\n\n"
           :unnarrowed t)
  ("p" "project" plain (function org-roam--capture-get-point)
           "%?"
           :file-name "${slug}"
           :head "#+TITLE: Project: ${title}\n#+SEQ_TODO: PLANNED(p) ACTIVE(A) HOLD(h) | DONE(d)\n\n"
           :unnarrowed t)
  ("b" "book" plain (function org-roam--capture-get-point)
           "%?"
           :file-name "${slug}"
           :head "#+TITLE: Book: ${title}\n#+CATEGORY: book\n#+SEQ_TODO: TODO(t) READING(r) PAUSED(p) | DONE(d) CANCELLED(c)\n\n* TODO [%] Book: ${title}\n* Notes"
           :unnarrowed t)
      ;;     ("p" "private" plain (function org-roam-capture--get-point)
      ;;      "%?"
      ;;      :file-name "private-${slug}"
      ;;      :head "#+TITLE: ${title}\n"
      ;;      :unnarrowed t)
           ))
  )
(require 'beancount "~/.timacs/beancount")
