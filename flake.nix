{
  description = "Chasinglogic's nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    dfm.url = "github:chasinglogic/dfm/main";
    projector.url = "github:chasinglogic/projector/master";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-stable,
    home-manager,
    dfm,
    projector,
    ...
  } @ inputs: let
    inherit (self) outputs;
    # Supported systems for your flake packages, shell, etc.
    systems = [
      # "aarch64-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    # This is a function that generates an attribute by calling a function you
    # pass to it, with each system as an argument
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    # Your custom packages
    # Accessible through 'nix build', 'nix shell', etc
    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    # Formatter for your nix files, available through 'nix fmt'
    # Other options beside 'alejandra' include 'nixpkgs-fmt'
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    # Your custom packages and modifications, exported as overlays
    overlays = import ./overlays {inherit inputs;};
    # Reusable nixos modules you might want to export
    # These are usually stuff you would upstream into nixpkgs
    nixosModules = import ./modules/nixos;
    # Reusable home-manager modules you might want to export
    # These are usually stuff you would upstream into home-manager
    homeManagerModules = import ./modules/home-manager;

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      "galactica" = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./hosts/galactica

          ./hosts/common/base.nix

          ./hosts/common/users/chasinglogic.nix
          ./hosts/common/purposes/virt-host.nix
          ./hosts/common/purposes/tailnet.nix
          ./hosts/common/purposes/gaming.nix
        ];
      };

      "raza" = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./hosts/raza

          ./hosts/common/base.nix

          ./hosts/common/purposes/virt-host.nix
          ./hosts/common/purposes/tailnet.nix
          ./hosts/common/purposes/server.nix

          ./hosts/common/users/chasinglogic.nix
        ];
      };

      "rocinante" = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./hosts/rocinante

          ./hosts/common/base.nix

          ./hosts/common/purposes/virt-host.nix
          ./hosts/common/purposes/tailnet.nix
          ./hosts/common/purposes/server.nix

          ./hosts/common/users/chasinglogic.nix
        ];
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      # TODO: do I need this if I integrate home-manager with the nixos config?
      "chasinglogic@galactica" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {
          inherit inputs outputs;
          homeDirectory = "/home/chasinglogic";
        };
        modules = [
          ./home-manager/home.nix
          ./home-manager/purposes/dev-machine.nix
          ./home-manager/purposes/dev-machine.linux.nix
          ./home-manager/purposes/work.nix
        ];
      };

      "chasinglogic@mac-arm" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-darwin;
        extraSpecialArgs = {
          inherit inputs outputs;
          homeDirectory = "/Users/chasinglogic";
        };
        modules = [
          ./home-manager/home.nix
          ./home-manager/purposes/dev-machine.nix
          ./home-manager/purposes/work.nix
        ];
      };
    };
  };
}
