#!/usr/bin/env bash
set -euo pipefail

# Install Nix (multi-user, 25.05)
curl --proto '=https' --tlsv1.2 -sSf -L https://nixos.org/nix/install | sh -s -- --daemon --yes

# Source Nix environment for current shell
if [ -f /etc/profile.d/nix-daemon.sh ]; then
  . /etc/profile.d/nix-daemon.sh
elif [ -f /etc/profile.d/nix.sh ]; then
  . /etc/profile.d/nix.sh
fi

# Enable flakes and nix-command
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf

# Ensure nix-command and flakes are enabled for this session
export NIX_CONFIG="extra-experimental-features = nix-command flakes"

# Pin nixpkgs and home-manager channels to 25.05
nix-channel --add https://channels.nixos.org/nixos-25.05 nixpkgs
nix-channel --add https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz home-manager
nix-channel --update

# Install Home Manager CLI (25.05) via flake
nix profile add github:nix-community/home-manager/release-25.05

# Bootstrap minimal Home Manager config
mkdir -p ~/.config/home-manager
cat > ~/.config/home-manager/home.nix <<EOF
{ config, pkgs, ... }:
{
  home.username = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";
  programs.home-manager.enable = true;
  home.stateVersion = "25.05";
}
EOF

# Run first home-manager switch
home-manager switch -b backup

# Source Home Manager session variables
if [ -f "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
  . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
fi

echo "Nix and Home Manager 25.05 installed! Open a new shell or source your ~/.bashrc."