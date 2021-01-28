;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

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

;;
;; USER
;;
(setq user-full-name "Tim von Oldenburg"
      user-mail-address "tim@tvooo.de")

;;
;; THEME, FONTS, COLORS
;;
(setq doom-font (font-spec :family "InputMonoNarrow" :size 21)
      doom-variable-pitch-font (font-spec :family "InputMonoNarrow" :height 120)
      doom-unicode-font (font-spec :family "all-the-icons")
      doom-big-font (font-spec :family "InputMonoNarrow" :size 28))

(setq doom-theme 'doom-flatwhite)
;; (set-face-attribute 'org-done nil
;;                     :weight 'semi-bold
;;                     :foreground "#b9a992"
;;                     )
(require 'org-checklist)

;;
;; COSMETICS
;;
(setq display-line-numbers-type nil)

;;
;; FOLDERS
;;
(setq tim/org-agenda-directory "~/org/")

;;
;; Deft
;;
(setq deft-directory tim/org-agenda-directory)
(setq deft-recursive t)

;;
;; ORG
;;
(setq org-directory tim/org-agenda-directory)
(setq org-roam-directory tim/org-agenda-directory)
(setq org-inbox-file "~/org/inbox.org")
(setq org-journal-dir "~/org/journal/")
(setq initial-buffer-choice "~/org/inbox.org")

(require 'find-lisp)
(after! org (setq org-agenda-files
                      (find-lisp-find-files tim/org-agenda-directory "\.org$")))

(after! org (setq org-indent-mode t
                  org-startup-truncated nil
                  org-ellipsis "..."))

;; TODOS
(after! org (setq org-todo-keywords '((sequence "TODO(t)" "NEXT(n)" "WAITING(w)" "PAUSED(p)" "|" "DONE(d)" "CANCELLED(c)"))))

;; TAGS
;; Don't right-align tags in headlines
(after! org
  (setq
   org-tags-exclude-from-inheritance '("project", "@project")
   org-tag-alist '(
                   (:startgroup . nil)
                   ("@office" . ?o) ("@home" . ?h)
                   (:endgroup . nil)
                   (:startgroup . nil)
                   ("@5mins" . ?5) ("@30mins" . ?3) ("@1hr" . ?1)
                   (:endgroup . nil)
                   ("@research" . ?R) ("project" . ?p) ("beccy" . ?b) ("@dread" . ?d))
                  org-stuck-projects
                        '("+project/-MAYBE-DONE" ("NEXT" "TODO") ("@buy")
                        "\\<IGNORE\\>")
                        ))

;; CAPTURE TEMPLATES
(after! org
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
                :tree-type week)

            ("r" "Weekly review" entry
                (file+olp+datetree "~/org/reviews.org" "Reviews")
                (file "~/org/templates/weeklyreview.template.org")
                )
            ))


  ;; Start capturing in insert mode
  (add-hook 'org-capture-mode-hook 'evil-insert-state)

   ;; That will put auto-saving all open org files on a timer. Performing changes to buffers from the org agenda overview, for example, doesn’t mark the buffer as needing to auto-save, as far as I understand. So this setting helps to auto-save all org buffers regularly.
   (add-hook 'auto-save-hook 'org-save-all-org-buffers)

   (global-auto-revert-mode t)

    (global-set-key (kbd "C-S-s-M-p") 'org-roam-find-file)
    (global-set-key (kbd "C-S-s-M-a") 'org-agenda-list)
    (global-set-key (kbd "C-S-s-M-c") 'org-capture)
  )


;; AGENDA
(org-super-agenda-mode t)
(setq org-agenda-block-separator nil
      org-agenda-compact-blocks t)
(after! org
  (setq
   org-log-repeat nil
   org-archive-location
      (concat tim/org-agenda-directory
              "archive/%s_archive::")
   ;; Show habits in agenda
   org-habit-show-habits t
   ;; Make sure calendar views start the week on Monday
   org-agenda-start-on-weekday 1
   calendar-week-start-day 1
   )
  (setq org-agenda-time-grid
        '((daily today require-timed)
          ()
           "......"
          "----------------------"
))
)

(setq org-agenda-custom-commands
      '(
        ("t" "Today" (
                      (agenda "" ((org-agenda-span 'day)
                                  (org-agenda-start-on-weekday nil)
                                  (org-agenda-start-day "+0d")
                                  (org-agenda-overriding-header "Today")
                                  (org-super-agenda-groups
                                   '(
                                     (:time-grid t)
                                     ))))

                      (todo "" ((org-agenda-overriding-header "Next")
                                (org-super-agenda-groups '(
                                                           (:name "Important" :and (:todo "NEXT" :priority>= "B"))
                                                           (:name "Next up" :todo "NEXT")
                                                           (:discard (:anything t))
                                                           ))))
                      ))


        ("o" "Overview"
         (
          (todo "" ((org-agenda-overriding-header "Active projects")
                    (org-super-agenda-groups
                     '((:name none      ; Disable super group header
                        :tag ("@project" "project")
                        )
                       (:discard (:anything t))))))
          (todo "" ((org-agenda-overriding-header "Currently reading")
                    (org-super-agenda-groups
                     '((:name none      ; Disable super group header
                        :todo "READING")
                       (:discard (:anything t))))))
          (todo "" ((org-agenda-overriding-header "Paused reading")
                    (org-super-agenda-groups
                     '((:name none      ; Disable super group header
                        :todo "PAUSED")
                       (:discard (:anything t))))))
          ))))

;; Mermaid
(setq ob-mermaid-cli-path "/home/tim/.yarn/bin/mmdc")

;;
;; EMOJIFY
;;
(setq emojify-display-style "unicode")
(setq emojify-emoji-set "twemoji-v2-22")
(global-emojify-mode t)


(after! org (set-popup-rule! "^Capture.*\\.org$" :side 'right :size .50 :select t :vslot 2 :ttl 3 :quit nil))
(after! org (set-popup-rule! "*helm*" :side 'bottom :size .30 :select t :vslot 5 :ttl 3))
(after! org (set-popup-rule! "*Org Agenda*" :side 'right :size .40 :select t :vslot 2 :ttl 3 :quit nil))


(plist-put +popup-defaults :modeline t)

(setq org-refile-targets (quote ((nil :maxlevel . 9)
                                 (org-agenda-files :maxlevel . 9))))


;; Start maximised
(if (eq initial-window-system 'x)                 ; if started by emacs command or desktop file
    (toggle-frame-maximized)
  (toggle-frame-fullscreen))

;; Hide UTF8 from modeline unless different
(defun doom-modeline-conditional-buffer-encoding ()
  (setq-local doom-modeline-buffer-encoding
              (unless (or (eq buffer-file-coding-system 'utf-8-unix)
                          (eq buffer-file-coding-system 'utf-8)))))
(add-hook 'after-change-major-mode-hook #'doom-modeline-conditional-buffer-encoding)

(setq doom-leader-key ","
      doom-localleader-key ", m")
