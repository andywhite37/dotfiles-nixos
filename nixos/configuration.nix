# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  #############################################################################
  # Imports
  #############################################################################
 
  imports =
    [
      ./hardware-configuration.nix
    ];

  #############################################################################
  # Boot
  #############################################################################

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  #############################################################################
  # Hardware
  #############################################################################
  
  hardware.enableAllFirmware = true;

  # Recommended for steam
  hardware.opengl.driSupport32Bit = true;

  #############################################################################
  # Networking
  #############################################################################

  networking.hostName = "mingnix"; # Define your hostname.
  networking.networkmanager.enable = true;
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  #############################################################################
  # i18n/l12n
  #############################################################################

  # Select internationalisation properties.
  i18n.consoleFont = "Lat2-Terminus16";
  i18n.consoleKeyMap = "us";
  i18n.defaultLocale = "en_US.UTF-8";

  # Set your time zone.
  time.timeZone = "America/Denver";

  #############################################################################
  # Nix packages
  #############################################################################

  nixpkgs.config.allowUnfree = true; 

  nixpkgs.config.packageOverrides = pkgs: rec {
    # Allow installations of packages from the unstable channel
    # Do this first: sudo nix-channel --add https://nixos.org/channels/nixos-unstable unstable
    unstable = import <unstable> {
      # Forward the base config, so we get the allowUnfree, etc. settings.
      config = config.nixpkgs.config;
    };

    idea.idea-ultimate = pkgs.lib.overrideDerivation pkgs.idea.idea-ultimate (attrs: {
      src = pkgs.fetchurl {
        url = "https://download.jetbrains.com/idea/ideaIU-2018.3.1-no-jdk.tar.gz";
        sha256 = "2812f396a096e462a9552f0186a7516ab5d4a3eaa6ebcef36af89db12bbd0d74";
      };
    });
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # or
  # $ nox wget
  environment.systemPackages = with pkgs; [
    ack
    #appimage-run # TODO: might want to remove appimage-run if I'm not using AppImages, it's pretty heavy
    ark
    unstable.autorandr
    bind # DNS tools
    binutils
    dnsutils
    file
    unstable.firefox
    gcc
    gdb
    git
    gitAndTools.hub
    gnome-themes-standard
    gnumake
    gnumeric
    google-chrome
    #unstable.idea.idea-ultimate # crashing on master see nixpkgs issue 52302
    idea.idea-ultimate
    inetutils
    jdk
    kdiff3
    leiningen
    lsof
    neovim
    neovim-qt
    nodejs-8_x
    nox
    openssl
    parted
    patchelf
    python
    python3
    qdirstat
    unstable.rambox
    remmina
    sbt
    scala
    slack
    spectacle
    spotify
    steam
    sudo
    terminator
    enlightenment.terminology
    unzip
    wget
    which
    vim
    unstable.vscode
    xsv
    yakuake
    zsh
  ];

  # Fonts
  fonts.fonts = with pkgs; [
    unstable.fira-code
    unstable.fira-code-symbols
    unstable.source-code-pro
  ];

  ################################################################################
  # Programs
  ################################################################################

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  ################################################################################
  # Audio
  ################################################################################

  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;

  ################################################################################
  # Services
  ################################################################################

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  ################################################################################
  # Users/Groups
  ################################################################################

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.awhite = {
    isNormalUser = true;
    uid = 1000;
    home = "/home/awhite";
    createHome = true;
    shell = "/run/current-system/sw/bin/zsh";
    extraGroups = [ "wheel" "networkmanager" ]; # wheel for sudo
  };

  ################################################################################
  # Security
  ################################################################################

  # Increase ulimits for Java crap
  security.pam.loginLimits = [
    {
      domain = "*";
      type = "soft";
      item = "nofile";
      value = "4096";
    }
    {
      domain = "*";
      type = "hard";
      item = "nofile";
      value = "10240";
    }
  ];

  ################################################################################
  # NixOS
  ################################################################################

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.09"; # Did you read the comment?
}
