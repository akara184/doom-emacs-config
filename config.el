;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
(setq fancy-splash-image "/home/akara184/diversao/imgs/lainbg.png")

;; place your private configuration here! remember, you do not need to run 'doom
;; sync' after modifying this file!


;; some functionality uses this to identify you, e.g. gpg configuration, email
;; clients, file templates and snippets. it is optional.
;; (setq user-full-name "john doe"
;;       user-mail-address "john@doe.com")

;; doom exposes five (optional) variables for controlling fonts in doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face

;; see 'c-h v doom-font' for documentation and more examples of what they
;; accept. for example:
;;(font-spec :family "hack" :size 200.0 :weight 'light)
(setq doom-font (font-spec :family "JetBrainsMono":size 18 ))

;; there are two ways to load a theme. both assume the theme is installed and
;; available. you can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. this is the default:
;;(setq doom-theme 'doom-tomorrow-night)
(setq doom-theme 'doom-xcode)
;;
;; this determines the style of line numbers in effect. if set to `nil', line
;; numbers are disabled. for relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; if you use `org' and don't want your org files in the default location below,
;; change `org-directory'. it must be set before org loads!
(setq org-directory "~/org/")

;; whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise doom's defaults may override your settings. e.g.
;;
;;   (after! package
;;     (setq x y))
;;
;; the exceptions to this rule:
;; - setting file/directory variables (like `org-directory')
;;   - setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'c-h v variable' to look up their documentation).
;;   - setting doom variables (which start with 'doom-' or '+').
;;
;; here are some additional functions/macros that will help you configure doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file.  emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; to get information about iny of these functions/macros, move the cursor over
;; the highlighted symbol at press 'k' (non-evil users must press 'c-c c k').
;; this will open documentation for it, including demos of how they are used.
;; alternatively, use `c-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; you can also tre 'gd' (or 'c-c c d') to jump to their definition and see how
; they are

;;To find commands use: "describe-key"

;;UNMAPPING SOME SHIT

(map!
     :map
     (global-map)
     "C-k" nil
     "C-j" nil)
(map! :map
       (evil-normal-state-map)
       "J" nil
       "K" nil)
(map! :map
      (evil-motion-state-map)
      "K" nil)


;;pretty line
(beacon-mode 1)


;;Some lsp-java config
(map! :after lsp-java
      :map (evil-normal-state-map)
       "C-g" #'lsp-java-generate-getters-and-setters)

(map! :after lsp-java
      :prefix "SPC c"
      :map (evil-normal-state-map)
      "a" #'lsp-execute-code-action)


(map! :after lsp-java
      :map
      (evil-normal-state-map)
      "C-o" #'lsp-organize-imports)

;;Add code definition in other window
(map! :prefix "SPC c"
      :map
      (evil-normal-state-map)
      "M-d" #'xref-find-definitions-window-other)

;;Opacity

;;(doom/set-frame-opacity <value>)

;;multiple cursors config
(map! :map (evil-normal-state-map)
      "R" #'evil-multiedit-match-all)
(map! :map (evil-normal-state-map)
  "M-d" #'evil-multiedit-match-and-next)
(map! :map (evil-visual-state-map)
  "M-d" #'evil-multiedit-match-and-next)
(map! :map (evil-insert-state-map)
  "M-d" #'evil-multiedit-toggle-marker-here)

(map! :map (evil-normal-state-map)
  "M-p" #'evil-multiedit-match-and-prev)
(map! :map (evil-visual-state-map)
  "M-p" #'evil-multiedit-match-and-prev)

(map! :map (evil-visual-state-map)
  "C-M-D" #'evil-multiedit-restore)

(map! :map (evil-normal-state-map)
  "RET" #'evil-multiedit-toggle-or-restrict-region)
(map! :map (evil-motion-state-map)
  "RET" #'evil-multiedit-toggle-or-restrict-region)

(map! :map (evil-motion-state-map)
  "C-n" #'evil-multiedit-next)
(map! :map (evil-motion-state-map)
  "C-n" #'evil-multiedit-next)

(map! :map (evil-multiedit-state-map)
  "C-p" #'evil-multiedit-prev)
(map! :map (evil-multiedit-state-map)
  "C-p" #'evil-multiedit-prev)

(evil-ex-define-cmd "ie[dit]" #'evil-multiedit-ex-match)
;;end of multiple cursors confi



;;open in full screnn
(add-hook 'window-setup-hook #'toggle-frame-maximized)

;;;;always show workspace
(after! persp-mode

  (defun workspaces-formatted ()
    (+doom-dashboard--center (frame-width) (+workspace--tabline)))

  (defun hy/invisible-current-workspace ()
    "the tab bar doesn't update when only faces change (i.e. the
current workspace), so we invisibly print the current workspace
name as well to trigger updates"
    (propertize (safe-persp-name (get-current-persp)) 'invisible t))

  (customize-set-variable 'tab-bar-format '(workspaces-formatted tab-bar-format-align-right hy/invisible-current-workspace))

  ;; don't show current workspaces when we switch, since we always see them
  (advice-add #'+workspace/display :override #'ignore)
  ;; same for renaming and deleting (and saving, but oh well)
  (advice-add #'+workspace-message :override #'ignore))

;; need to run this later for it to not break frame size for some reason
(run-at-time nil nil (cmd! (tab-bar-mode +1)))
;;end always shows workspace
(setq tab-always-indent t)



;;random stuffs

(setq org-hide-emphasis-markers t)

(setq org-emphasis-alist
  '(("*" (bold :slant italic :weight black :foreground "Deep Sky Blue"  )) ;; this make bold both italic and bold, but not color change
    ("/" (italic :foreground "dark salmon" )) ;; italic text, the text will be "dark salmon"
    ("_" underline :foreground "cyan" ) ;; underlined text, color is "cyan"
    ("=" (:background "snow1" :foreground "deep slate blue" )) ;; background of text is "snow1" and text is "deep slate blue"
    ("~" (:background "PaleGreen1" :foreground "dim gray" ))
    ("+" (:strike-through nil :foreground "lime green" ))))

(setq image-dired-thumbnail-display-external t)
(setq auto-save-default t)
(setq cua-mode t )
(setq neo-theme 'icons)



