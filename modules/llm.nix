{ pkgs, inputs, user, ... }: {

  environment.systemPackages = with inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}; [
    pi
    opencode
    pkgs.llama-cpp-rocm
  ];
}
