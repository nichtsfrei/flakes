Contains various system definitions.

TBD

# Clean up

```
sudo nix-env --delete-generations +7 --profile /nix/var/nix/profiles/system
sudo nix-collect-garbage --delete-older-than 5d
nix store optimise
sudo nixos-rebuild boot
```

# devvm

Unlike on my my actual machines I don't use btrfs on my vm.

Mainly because it is not worth it.

## Setup

Currently broken with kernel 6.3.3.

switching to fedora and using nix seems easier.

On utm:

```
parted /dev/vda -- mklabel gpt
parted /dev/vda -- mkpart primary 512MB -8GB
parted /dev/vda -- mkpart primary linux-swap -8GB 100%
parted /dev/vda -- mkpart ESP fat32 1MB 512MB
parted /dev/vda -- set 3 esp on
mkfs.ext4 -L nixos /dev/vda1
mkswap -L swap /dev/vda2
mkfs.fat -F 32 -n boot /dev/vda3
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
swapon /dev/vda2
nixos-generate-config --root /mnt
cp /mnt/etc/nixos/hardware-configuration.nix devvm1.nix
# get the uuid for system specifics
# clone this repository and set the machine up
nixos-install --flake /tmp/flake#devvm1
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

