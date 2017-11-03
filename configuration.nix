{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  # set your time zone.
  time.timeZone = "Europe/Jerusalem";

  environment.systemPackages = [
    pkgs.wget
    pkgs.stack
    pkgs.gnumake
    pkgs.gitAndTools.gitFull
    pkgs.blas
    pkgs.atlas

    (import /etc/nixos/emacs.nix { inherit pkgs; } )
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.guest = {
    name = "Yotam";
    group = "users";
    createHome = true;
    shell = "/run/current-system/sw/bin/bash";
    uid = 1000;
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.03";

  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.desktopManager.plasma5.enable = true;
}
