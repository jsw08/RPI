{
  description = "Build image";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

  outputs = {
    self,
    nixpkgs,
  }: rec {
    nixosConfigurations.rpi2 = nixpkgs.lib.nixosSystem {
#      specialArgs = {modulesPath = "${nixpkgs}/nixos/modules";};
      modules = [
        "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-raspberrypi.nix"
        ./core.nix
	./gadget_ethernet.nix
      ];
    };

    images.rpi2 = nixosConfigurations.rpi2.config.system.build.sdImage;
  };
}
