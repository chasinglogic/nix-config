default:
    @just --list

fmt:
    nix fmt .

apply host="" user="":
    #!/usr/bin/env bash
    set -e

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

    if [ -x $(which home-manager 2>/dev/null) ]; then
        echo "Detected home-manager, doing a rebuild."
        home-manager switch --flake ".#$USERNAME@$HOST"
    fi 

test host:
    #!/usr/bin/env bash
    log=$(mktemp)
    nixos-rebuild build-vm --flake .#{{host}} | tee "$log"
    script=$(tail -n1 "$log" | sed 's/Done. The virtual machine can be started by running //')
    export QEMU_NET_OPTS=hostfwd=tcp::2221-:22
    echo "Machine can be accessed with:"
    echo "    ssh -p 2221 localhost"
    $script
