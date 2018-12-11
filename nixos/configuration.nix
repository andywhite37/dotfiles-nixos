# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "mingnix"; # Define your hostname.
  networking.networkmanager.enable = true;
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.consoleFont = "Lat2-Terminus16";
  i18n.consoleKeyMap = "us";
  i18n.defaultLocale = "en_US.UTF-8";

  # Set your time zone.
  time.timeZone = "America/Denver";

  # For Google Chrome, etc.
  nixpkgs.config.allowUnfree = true; 

  # Package overrides
  nixpkgs.config.packageOverrides = pkgs: rec {
    # Allow installations of packages from the unstable channel
    # Do this first: sudo nix-channel --add https://nixos.org/channels/nixos-unstable unstable
    unstable = import <unstable> {
      # Forward the base config, so we get the allowUnfree, etc. settings.
      config = config.nixpkgs.config;
    };

    #idea.idea-ultimate = pkgs.lib.overrideDerivation pkgs.idea.idea-ultimate (attrs: {
      #src = pkgs.fetchurl {
        #url = "https://download.jetbrains.com/idea/ideaIU-2018.3.tar.gz";
        #sha256 = "0pdbi6n42raa0pg38i9dsg44rfz4kj4wmzkr5n9xi4civdbqk8xw";
      #};
    #});
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    ack
    #appimage-run # TODO: might want to remove appimage-run if I'm not using AppImages, it's pretty heavy
    ark
    file
    unstable.firefox
    gcc
    gdb
    git
    gnome-themes-standard
    unstable.google-chrome
    unstable.idea.idea-ultimate
    jdk
    kdiff3
    neovim
    neovim-qt
    nodejs-8_x
    nox
    openssl
    parted
    patchelf
    qdirstat
    unstable.rambox
    sbt
    scala
    slack
    sudo
    terminator
    enlightenment.terminology
    wget
    which
    vim
    unstable.vscode
    yakuake
    zsh
  ];

  # Fonts
  fonts.fonts = with pkgs; [
    unstable.fira-code
    unstable.fira-code-symbols
    unstable.source-code-pro
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.awhite = {
    isNormalUser = true;
    uid = 1000;
    home = "/home/awhite";
    createHome = true;
    shell = "/run/current-system/sw/bin/zsh";
    extraGroups = [ "wheel" ]; # wheel for sudo
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.09"; # Did you read the comment?
}
