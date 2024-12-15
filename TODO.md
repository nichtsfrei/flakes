1. create update systemd file that runs:
  - distrobox update for each installed user
  - flake update for each installed user
  - nixos update
2. remove home manager, to be able to reuse .config files within a container without having to share nix store
  - differentiate between harmless (no lua non-sense) configuration that may be put as a system default by creating a flake in dotfiles
  - for the other ones ... dunno, maybe a smart install step?
3. clean up
4. write functions to make it easier to create new machine definitions
