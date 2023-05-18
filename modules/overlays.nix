{
  inputs,
  nixpkgs,
  ...
}: {
  overlays = [
    # channels
    (final: prev: {
      inherit (inputs.penvim.packages.${final.system}) penvim;
    })
  ];
}
