{ pkgs, inputs, user, ... }: {

  environment.systemPackages = with inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}; [
    pi
    pkgs.llama-cpp-rocm
  ];
}
