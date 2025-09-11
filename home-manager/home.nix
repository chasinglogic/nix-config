# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  dfm,
  projector,
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

  nix = {
    package = pkgs.nix;
    settings.experimental-features = ["nix-command" "flakes"];
  };

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

  home.packages = [
    # Encryption
    pkgs.sops
    pkgs.age
    pkgs.cosign

    # Kubernetes
    pkgs.kubectl
    # Not supported on M series Macs atm and I don't really use it so commented out for
    # now
    # helm
    pkgs.kube-capacity
    pkgs.kind

    # Container security scanning tools
    pkgs.grype
    pkgs.syft

    # Still running some talos clusters
    pkgs.talosctl

    # Tooling for shell scripts
    pkgs.shellcheck
    pkgs.shfmt

    # Load testing tool
    pkgs.oha

    # For building and publishing my blog
    pkgs.hugo

    # Command line speed tester
    pkgs.hyperfine

    pkgs.gotools
    pkgs.go-migrate
    pkgs.goreleaser
    pkgs.golangci-lint

    pkgs.just
    pkgs.yq
    pkgs.grpcurl
    pkgs.zenith
    pkgs.hwatch
    pkgs.zellij

    pkgs.python3
    pkgs.elixir
    pkgs.rustc
    pkgs.cargo
    pkgs.clang

    # AI stuff
    pkgs.unstable.gemini-cli

    pkgs.nodejs
    pkgs.nodePackages.prettier
    pkgs.nodePackages.eslint
    pkgs.nodePackages.pnpm

    # IaC tools
    pkgs.awscli2
    pkgs.google-cloud-sdk
    pkgs.terragrunt
    pkgs.opentofu
    pkgs.pulumi

    dfm
    projector
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

  programs.ghostty.enable = true;

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
  programs.fish = {
    enable = true;
  };
  programs.direnv = {
    enable = true;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  dconf.enable = true;
  dconf.settings = {
    "org/gnome/desktop/input-sources" = {
      xkb-options = ["ctrl:nocaps" "lv3:ralt_alt"];
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
