Contains various system definitions.

TBD

# Clean up

```
sudo nix-env --delete-generations +7 --profile /nix/var/nix/profiles/system
sudo nix-collect-garbage --delete-older-than 5d
nix store optimise
sudo nixos-rebuild boot
```

# darwin
## Setup 

Manually to get rid of that annoying chime:
```
sudo nvram StartupMute=%01
```

Initial build command:
```
# login to apple, so that xcode and prime video can be installed
# urgh
/bin/bash -c "$(curl -fsSL https://nixos.org/nix/install)"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
nix build --extra-experimental-features "nix-command flakes" .#darwinConfigurations.$name.system
./result/sw/bin/darwin-rebuild switch --flake .#$name
```

There will be an error in the first run, just execute the proposed commands.

On the error messages that already exist: delete the files so that nix can manage them.

