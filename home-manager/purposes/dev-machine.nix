{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    delta.enable = true;
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
  };

  home.packages = with pkgs; [
    firefox
    google-chrome

    # Encryption
    sops
    age
    cosign

    # Kubernetes
    kubectl
    kubebuilder
    k9s
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
    hwatch
    zellij
    gh
    act
    git-filter-repo
    # Still use this for work settings when I have to deal with python especially.
    mise

    elixir
    rustc
    cargo
    gcc

    # Python Stuff
    python3

    # AI stuff
    gemini-cli

    nodejs
    nodePackages.prettier
    nodePackages.eslint
    nodePackages.pnpm

    # IaC tools
    awscli2
    (google-cloud-sdk.withExtraComponents [google-cloud-sdk.components.gke-gcloud-auth-plugin])
    terragrunt
    opentofu
    tflint
    pulumi

    stable.postgresql
    dbeaver-bin

    dfm
    projector
  ];
}
