#!/bin/sh
set -e

if [ "$(id -u)" -eq 0 ]; then
    echo "Run me as normal user, not root!"
    exit 1
fi

outfile=$(mktemp)
trap 'rm -f "$outfile"' EXIT

echo "Downloading Installer..."

set -- "XDG_CONFIG_HOME=$XDG_CONFIG_HOME"

curl -sS https://github.com/gujarathisampath/VeeeCordInstaller/releases/latest/download/VeeeCordInstallerCli-Linux \
  --output "$outfile" \
  --location

chmod +x "$outfile"

echo
echo "Now running VeeeCordInstaller"
echo "Do you want to run as root? [Y|n]"
echo "This is necessary if Discord is in a root owned location like /usr/share or /opt"
printf "> "
read -r runAsRoot

opt="$(echo "$runAsRoot" | tr "[:upper:]" "[:lower:]")"

if command -v sudo >/dev/null; then
  echo "Running with sudo"
  sudo env "$@" "$outfile"
elif command -v doas >/dev/null; then
  echo "Running with doas"
  doas env "$@" "$outfile"
else
  echo "Neither sudo nor doas were found. Please install either of them to proceed."
fi
