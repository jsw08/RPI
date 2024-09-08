{
  description = "Build image";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

  outputs = {
    self,
    nixpkgs,
  }: let 
    inherit (nixpkgs) lib;
    forAllSystems = lib.genAttrs lib.systems.flakeExposed;
  in rec {
    nixosConfigurations.rpi = lib.nixosSystem {
#      specialArgs = {modulesPath = "${nixpkgs}/nixos/modules";};
      modules = [
        "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-raspberrypi.nix"
        ./core.nix
	./gadget_ethernet.nix
      ];
    };

    packages = forAllSystems (system: {default = nixosConfigurations.rpi.config.system.build.sdImage;});
  };
}
