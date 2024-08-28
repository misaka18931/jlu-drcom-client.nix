{
  description = "";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages."${system}";
  in {
    packages.x86_64-linux.jlu-drcom-client = pkgs.callPackage ./package.nix {};
    packages.x86_64-linux.default = self.packages.x86_64-linux.jlu-drcom-client;
    nixosModules.default = import ./module.nix;
  };
}