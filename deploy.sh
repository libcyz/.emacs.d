#!/bin/bash
# 按 MANIFEST 把仓库里的文件软链接到 $HOME 下
# 用法：./deploy.sh [MANIFEST]

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

symlinkFile() {
    filename="$SCRIPT_DIR/$1"
    destination="$HOME/$2/$1"

    mkdir -p "$(dirname "$destination")"

    if [ -L "$destination" ]; then
        echo "[WARNING] $filename already symlinked"
        return
    fi

    if [ -e "$destination" ]; then
        echo "[ERROR] $destination exists but it's not a symlink. Please fix that manually"
        exit 1
    fi

    ln -s "$filename" "$destination"
    echo "[OK] $filename -> $destination"
}

deployManifest() {
    while IFS='|' read -r filename operation destination; do
        if [[ -z "$filename" || "$filename" =~ ^# ]]; then
            continue
        fi

        case $operation in
            symlink)
                symlinkFile "$filename" "$destination"
                ;;

            *)
                echo "[WARNING] Unknown operation $operation. Skipping..."
                ;;
        esac
    done < "$SCRIPT_DIR/$1"
}

deployManifest "${1:-MANIFEST}"
