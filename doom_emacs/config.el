;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; 不知道为什么默认情况下 latex-mode 里不会启用 lsp
(after! eglot
  (add-to-list 'eglot-server-programs '(latex-mode . ("texlab"))))
;;

;; 设置 org-mode 相关的路径
(setq org-directory "~/org/"
      org-roam-directory "~/org/org-roam")
;;

;; 设置中文字体相关的内容
;; (setq doom-font (font-spec :family "Iosevka" :weight 'medium))
(cnfonts-mode 1)

;; (defun my-cjk-font()
;;   (dolist (charset '(kana han cjk-misc symbol bopomofo))
;;     (set-fontset-font t charset (font-spec :family "LXGW WenKai Mono"))))

;; (add-hook 'after-setting-font-hook #'my-cjk-font)
;;

;; 在 latex 中可以默认输入" ，之前由于auctex 和 smartparents 的关系做不到
(map! :map TeX-mode-map
      :i "\"" 'self-insert-command)

(after! smartparens-latex
  (let ((modes '(tex-mode plain-tex-mode latex-mode LaTeX-mode)))
    (sp-local-pair modes "``" nil :actions :rem)
    (sp-local-pair modes "``" "''"
                        :unless '(sp-latex-point-after-backslash sp-in-math-p))))
;;

;; 在 org-mode 中可以使用 tab 键来在 YASnippet 的 snippet 各域之间跳转。
(defun my/org-tab-conditional ()
  (interactive)
  (if (yas-active-snippets)
      (yas-next-field-or-maybe-expand)
    (org-cycle)))

(map! :after evil-org
      :map evil-org-mode-map
      :i "<tab>" #'my/org-tab-conditional)
;;


(use-package! evil
  :init
  (setq evil-want-fine-undo t))

;; Smartparens bindings set to be called with SPC + l as prefix
;; (map!
;;  :map smartparens-mode-map
;;  :leader (:prefix ("l" . "Lisps")
;;           :nvie "f" #'sp-forward-sexp
;;           :nvie "b" #'sp-backward-sexp
;;           :nvim "u" #'sp-up-sexp
;;           :nvim "d" #'sp-down-sexp
;;           :nie "k" #'sp-kill-sexp
;;           :nie "s" #'sp-split-sexp
;;           :nie "(" #'sp-wrap-round
;;           :nie "[" #'sp-wrap-square
;;           :nie "{" #'sp-wrap-curly))
;;

;; 让 smartparens 只处理 s-exp 不识别其他符号
(use-package! smartparens
  :config
  (setq sp-navigate-consider-symbols nil))

;;
(use-package! separedit
  :commands separedit
  :config
  (map! :leader
        :desc "Edit with separedit" "e" #'separedit))
;;

;;
;; (use-package! which-key
;;   :config
;;   (map! :map which-key-mode-map
;;         "<kp-1>" #'which-key-C-h-dispatch)
;;   (setq which-key-paging-prefixes '("<kp-1>")))

;; 可以在编辑 tag 时，open tag 和 closing tag 同步
(use-package! sgml-mode
  :hook (web-mode . sgml-electric-tag-pair-mode))
