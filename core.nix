{
  lib,
  pkgs,
  modulesPath,
  ...
}: let
  user = "user";
in {
  # User
  users.mutableUsers = false;
  users.users.${user} = {
    isNormalUser = true;
    initialPassword = "changeme";
    extraGroups = ["wheel" "networkmanager"];
  };
  services.getty.autologinUser = user;

  # SSH
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
  };

  # Wireless
  hardware = {
    firmware = [
      pkgs.raspberrypiWirelessFirmware
    ];
  };
  networking.wireless.enable = true;

  # Boot
  boot = {
    initrd.includeDefaultModules = false;
    initrd.kernelModules = ["ext4" "mmc_block"];
    supportedFilesystems = lib.mkForce ["vfat" "ext4"];
  };

  # Slim it down
  i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" ];
  hardware.enableRedistributableFirmware = lib.mkOverride 0 false;
  documentation.enable = false;
  security.polkit.enable = false;
  services.udisks2.enable = false;
  xdg.mime.enable = false;
  programs.command-not-found.enable = false;

  # Nix & System
  nixpkgs.overlays = [
    (final: super: {
      llvmPackages = super.llvmPackages_14;
      cmake = super.cmake.overrideAttrs (old: {env.NIX_CFLAGS_COMPILE = "-latomic";});
    })
  ];
  disabledModules = [
    "${modulesPath}/profiles/all-hardware.nix"
    "${modulesPath}/profiles/base.nix"
  ];

  environment.defaultPackages = with pkgs; [ # some default packages.
    neovim
    libraspberrypi
    curl
    wget
  ];

  nixpkgs.config.allowUnsupportedSystem = true;
  nixpkgs.hostPlatform.system = "armv6l-linux";
  nixpkgs.buildPlatform.system = "x86_64-linux"; # changeme if you want to build on a different architecture.

  system.stateVersion = "24.05";
}
