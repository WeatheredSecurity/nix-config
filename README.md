# nix-config
internal flake for use with home manager and nixos - configurable for any product hosts and general workstations

# installation first time use
the first time use of the flake requires internet.
the flake can be installed the included installation script 'wizard-install.sh'. the wizard will guide you through selecting a host, or customizing your config. 

# maintenance and updating
updating the flake requires internet.
the flake will be updated with the included 'nix-rebuild.sh' script. this will pull any new packages, package updates, and rebuild them to match the flake.

# flake overview
```bash
.
├── flake.nix
├── flake.lock
├── homeManagerModules
│   ├── wifi
│   ├── bt
│   ├── bladeRF

```
