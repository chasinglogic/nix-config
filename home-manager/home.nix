# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  homeDirectory,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  home = {
    username = "chasinglogic";
    homeDirectory = homeDirectory;
  };

  home.packages = with pkgs; [
    # Encryption
    sops
    age
    cosign

    # Kubernetes
    kubectl
    # Not supported on M series Macs atm and I don't really use it so commented out for
    # now
    # helm
    kube-capacity
    kind

    # Container security scanning tools
    grype
    syft

    # Still running some talos clusters
    talosctl

    # Tooling for shell scripts
    shellcheck
    shfmt

    # Load testing tool
    oha

    # For building and publishing my blog
    hugo

    # Command line speed tester
    hyperfine

    gotools
    go-migrate
    goreleaser
    golangci-lint

    just
    yq
    grpcurl
    zenith

    python
    ruby
    elixir
    rustc
    cargo

    node
    nodePackages.prettier
    nodePackages.eslint
    nodePackages.pnpm

    # IaC tools
    awscli2
    google-cloud-sdk
    terragrunt
    opentofu
    pulumi
  ];

  # Enable home-manager and git
  programs.home-manager.enable = true;

  # General dev tooling
  programs.git = {
    enable = true;
    delta.enable = true;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  programs.ripgrep.enable = true;
  programs.fd.enable = true;
  programs.fzf.enable = true;
  programs.bat.enable = true;
  programs.jq.enable = true;

  # Python tooling
  programs.uv.enable = true;
  programs.ruff = {
    enable = true;
    settings = {
      line-length = 100;
      per-file-ignores = {"__init__.py" = ["F401"];};
      lint = {
        select = ["E4" "E7" "E9" "F"];
        ignore = [];
      };
    };
  };

  # Go tooling
  programs.go = {
    enable = true;
    # This is relative to $HOME
    goPath = "Code/go";
    # This is relative to goPath
    goBin = "bin";
  };

  # Shell environment
  # programs.fish = {
  #   enable = true;
  # };
  programs.direnv = {
    enable = true;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
