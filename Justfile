default:
    @just --list

fmt:
    nix fmt .

apply host="" user="":
    #!/usr/bin/env bash

    HOST={{host}}
    if [ -z "$HOST" ]; then
        HOST=$(hostname)
    fi

    USERNAME={{user}}
    if [ -z "$USERNAME" ]; then
        USERNAME=$USER
    fi

    echo "Applying $USERNAME@$HOST"
    
    if [ -x $(which nixos-rebuild 2>/dev/null) ]; then
        echo "Detected NixOS, doing a rebuild."
        sudo nixos-rebuild switch --flake ".#$HOST"
    fi

    home-manager switch --flake ".#$USERNAME@$HOST"
