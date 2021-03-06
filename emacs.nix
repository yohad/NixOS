{ pkgs ? import <nixpkgs> {} }:

let
  emacsEcosystem = pkgs.emacsPackagesNg;
  trivialBuild = pkgs.callPackage <nixpkgs/pkgs/build-support/emacs/trivial.nix> {
    emacs = pkgs.emacs;
  };
  
  my-mode = emacsEcosystem.trivialBuild {
    pname = "my-mode";
    version = "2017-10-02";
    src = pkgs.writeText "default.el" ''
      ;; Haskell
      (add-hook 'haskell-mode-hook 'intero-mode)
      (add-hook 'haskell-mode-hook 'flymake-hlint-load)

      ;; Magit
      (global-set-key (kbd "C-x g") 'magit-status)
      (global-set-key (kbd "C-x M-x") 'magit-dispatch-popup)

      ;; Org
      (setq org-agenda-files '("~/org"))
      
      ;; General
      (setq tab-width 4)
      (setq-default indent-tabs-mode nil)

      ;; File Recovery
      (setq backup-directory-alist `((".*" . "~/.saves")))

    '';
  };      
in
  emacsEcosystem.emacsWithPackages (epkgs: (with epkgs.melpaStablePackages; [
    magit
    intero
    flycheck
    flymake-hlint
    nix-mode
    fountain-mode
    yaml-mode
  ]) ++ (with epkgs.melpaPackages; [
    undo-tree
  ]) ++ (with epkgs.elpaPackages; [
    auctex
    beacon
  ]) ++ [
    pkgs.notmuch
  ] ++ [my-mode])
