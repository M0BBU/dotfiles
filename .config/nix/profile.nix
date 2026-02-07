# profile.nix

{ pkgs ? import <nixpkgs> { }, name ? "user-env" }: with pkgs;

buildEnv {
  inherit name;
  # to get all the symlink we need
  extraOutputsToInstall = [ "out" "man" "lib" ];
  paths = [
    # ... put your packages here
    tmux
    ripgrep
    nix-direnv
    direnv
    fzf
    helix
    google-cloud-sdk
    beancount

    # this will create a script that will rebuild and upgrade your setup. Is using shell script syntax
    (writeScriptBin "nix-rebuild" ''
      #!${stdenv.shell}
      cd ~/.config/nix || exit 1
      nix flake update
      # Why do i need to specify nix here??????????
      nix profile upgrade nix
    '')

    # puts in your root the nixpkgs version
    (writeTextFile {
      name = "nixpkgs-version";
      destination = "/nixpkgs-version";
      text = lib.version;
    })
  ];
}
