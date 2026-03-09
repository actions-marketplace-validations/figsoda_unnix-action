#!/usr/bin/env bash

set -euo pipefail

kernel=$(uname -s)

if command -v unnix >/dev/null 2>&1; then
    echo "found unnix at $(command -v unnix)"
else
    arch=$(uname -m)
    case "$arch-$kernel" in
        aarch64-Darwin | arm64-Darwin)
            target=aarch64-apple-darwin
            ;;
        aarch64-Linux | arm64-Linux)
            target=aarch64-unknown-linux-musl
            ;;
        x86_64-Linux)
            target=x86_64-unknown-linux-musl
            ;;
        *)
            echo "::error title=unsupported system::$arch-$kernel is not supported by unnix-action, please install unnix manually before this step"
            exit 1
            ;;
    esac
    curl -Lfo /usr/local/bin/unnix "https://github.com/figsoda/unnix/releases/download/v$INPUT_VERSION/unnix-$target"
    chmod +x /usr/local/bin/unnix
fi

if [ "$kernel" = Darwin ]; then
    unnix_root=$HOME/Library/Caches/unnix
    echo nix | sudo tee -a /etc/synthetic.conf >/dev/null
    sudo /System/Library/Filesystems/apfs.fs/Contents/Resources/apfs.util -t || true
    sudo diskutil apfs addVolume "$(stat -f "%Sd" / | sed 's/s[0-9]*$//')" APFS "unnix store" -mountpoint /nix
else
    unnix_root=${XDG_CACHE_HOME:-$HOME/.cache}/unnix
    sudo mkdir -p /nix
fi

unnix ci github --directory "$INPUT_DIRECTORY" --locked
sudo ln -s "${unnix_root}/store" /nix/store
