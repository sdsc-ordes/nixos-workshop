# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  inputs,
  outputs,
  ...
}:
{
  imports = [
    inputs.disko.nixosModules.disko

    ./hardware-configuration.nix
    ./boot.nix

    # Load the NixOS age encryption module to encrypt/decrypt
    # secrets with this NixOS configuration
    inputs.agenix.nixosModules.default

    # Include all other specifications.
    (outputs.nixosModules.windowing { inherit config pkgs; })
    outputs.nixosModules.display
    outputs.nixosModules.keyboard
    outputs.nixosModules.fonts
    outputs.nixosModules.time
    outputs.nixosModules.environment
    outputs.nixosModules.networking
    outputs.nixosModules.security

    outputs.nixosModules.services

    outputs.nixosModules.sound
    outputs.nixosModules.printing

    outputs.nixosModules.virtualization-vm
    outputs.nixosModules.containerization

    outputs.nixosModules.packages
    outputs.nixosModules.programs

    outputs.nixosModules.user
    outputs.nixosModules.settings

    outputs.nixosModules.nix

    # # Load home-manager as a part of the NixOS configuration.
    # inputs.home-manager.nixosModules.home-manager
    # (outputs.nixosModules.home-manager {
    #   inherit
    #     config
    #     inputs
    #     outputs
    #     ;
    # })
  ];

  config = {
    nixpkgs = {
      # You can add overlays here.
      overlays = [
        # NOTE: We are not eagerly using overlays so far, we pass inputs directly to modules.
        #       Overlays is a recursive mechanism which is only used when a
        #       package needs to be overwrittern globally.

        # Add overlays of your own flake exports (from overlays and pkgs dir):
        outputs.overlays.additions
        outputs.overlays.modifications
        outputs.overlays.unstable
      ];
    };

    # Only needed to guard commands in the `justfile` which
    # are only means to be executed on a NixOS system.
    environment.variables = {
      NIXOS_ON_VM = "true";
    };

    ### NixOS Release Settings===================================================
    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "24.11";
    # ===========================================================================
  };
}
