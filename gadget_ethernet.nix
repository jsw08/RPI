{lib, pkgs, modulesPath, ...}: let
  configTxt = pkgs.writeText "config.txt" ''
    # Default stuff
    avoid_warnings=1

    [pi0]
    kernel=u-boot-rpi0.bin

    [pi1]
    kernel=u-boot-rpi1.bin

    # USB Ethernet gadget
    [all]
    dtoverlay=dwc2

  ''; 
in {
  imports = [
    "${modulesPath}/installer/sd-card/sd-image.nix"
  ]; 

  boot.kernelParams = [
    "modules-load=dwc2,g_ether" 
  ]; 

  sdImage.populateFirmwareCommands = /* These commands are copy and pasted from https://github.com/NixOS/nixpkgs/blob/nixos-24.05/nixos/modules/installer/sd-card/sd-image-raspberrypi.nix, to overwrite the config.txt */ lib.mkForce '' 
      (cd ${pkgs.raspberrypifw}/share/raspberrypi/boot && cp bootcode.bin fixup*.dat start*.elf $NIX_BUILD_TOP/firmware/)
      cp ${pkgs.ubootRaspberryPiZero}/u-boot.bin firmware/u-boot-rpi0.bin
      cp ${pkgs.ubootRaspberryPi}/u-boot.bin firmware/u-boot-rpi1.bin
      cp ${configTxt} firmware/config.txt
  '';
}
