# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  #############################################################################
  # Imports
  #############################################################################

  imports = [
    ./hardware-configuration.nix
  ];

  #############################################################################
  # Boot
  #############################################################################
  
  # Use the latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  #############################################################################
  # Hardware/Video/Audio
  #############################################################################
  
  hardware.enableAllFirmware = true;

  # Recommended for steam
  hardware.opengl.driSupport32Bit = true;

  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;

  #############################################################################
  # Networking
  #############################################################################

  # Define your hostname.
  networking.hostName = "mingnix"; 

  networking.networkmanager.enable = true;

  # Enables wireless support via wpa_supplicant (TODO: doesn't seem to be necessary?)
  #networking.wireless.enable = true;  

  # Configure network proxy if necessary
  #networking.proxy.default = "http://user:password@proxy:port/";
  #networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Open ports in the firewall.
  #
  #networking.firewall.allowedTCPPorts = [ ... ];
  #networking.firewall.allowedUDPPorts = [ ... ];
  #
  # Or disable the firewall altogether.
  #
  #networking.firewall.enable = false;

  #############################################################################
  # i18n/l12n
  #############################################################################

  i18n.consoleFont = "Lat2-Terminus16";
  i18n.consoleKeyMap = "us";
  i18n.defaultLocale = "en_US.UTF-8";

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

    # Install the latest version of IDEA, but still using the stable channel.
    # This is done because the stable version tends to lag behind, but the unstable
    # version tends to have problems.
    idea.idea-ultimate = pkgs.lib.overrideDerivation pkgs.idea.idea-ultimate (attrs: {
      src = pkgs.fetchurl {
        url = "https://download.jetbrains.com/idea/ideaIU-2019.2-no-jbr.tar.gz";
        sha256 = "78588740bbd5c8054316d6b4217ff79a39cbecf3ca762db2b450b4cdbcc39f72";
      };
    });
  };

  #############################################################################
  # System-level packages
  #############################################################################

  environment.systemPackages = with pkgs; [
    ack
    alacritty
    apacheHttpd
    appimage-run
    ark
    autorandr
    bind
    binutils
    brave
    cabal-install
    cabal2nix
    cmake
    dnsutils
    dpkg
    file
    firefox
    gcc
    gdb
    git
    gitAndTools.hub
    gnome-themes-standard
    gnumake
    gnumeric
    google-chrome
    gwenview
    idea.idea-ultimate
    imagemagickBig
    inetutils
    jdk
    jq
    kdiff3
    killall
    ksystemlog
    leiningen
    libpng
    lsof
    lzip
    unstable.lutris
    mariadb
    ncat
    neovim
    neovim-qt
    ngrok
    nix-index
    nix-prefetch-git
    nmap-graphical
    nodePackages.node2nix
    nodejs-8_x
    nox
    okular
    opam
    openssl
    parted
    patchelf
    php
    plasma-workspace
    pngquant
    unstable.postman
    psc-package
    # purescript was broken in 19.03 at this time - remove unstable when possible
    unstable.purescript
    python
    python3
    qdirstat
    unstable.rambox
    remmina
    sbt
    scala
    signal-desktop
    slack
    spectacle
    spotify
    # For purescript to compile via stack, I had to add this to ~/.stack/config.yaml
    #
    # nix:
    #   enable: true
    #   packages: [zlib.dev, zlib.out]
    stack
    steam
    steam-run
    sudo
    terminator
    enlightenment.terminology
    tree
    unzip
    wget
    which
    wire-desktop
    vim
    unstable.vscode
    xclip
    xsel
    xsv
    yakuake
    zip
    zsh
  ];

  #############################################################################
  # Fonts
  #############################################################################

  fonts.fonts = with pkgs; [
    fira-code
    fira-code-symbols
    noto-fonts
    noto-fonts-emoji
    source-code-pro
  ];

  ################################################################################
  # Programs
  ################################################################################

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  ################################################################################
  # Services
  ################################################################################

  # OpenSSH daemon
  services.openssh = {
    enable = true;
  };

  # CUPS (printing)
  # Note: just using Google Cloud Print instead
  #services.printing = {
    #enable = true;
    #drivers = [ pkgs.epson-escpr ];
  #};

  # X11 windowing system
  services.xserver = {
    enable = true;
    layout = "us";
    xkbOptions = "eurosign:e";

    # Enable touchpad support.
    libinput = {
      enable = true;
    };

    # Enable the KDE Desktop Environment.
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;
  };

  # MariaDB (MySQL)
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };

  # Apache web server (httpd)
  services.httpd = {
    enable = true;
    enablePHP = true;
    enableUserDir = true;
    adminAddr = "admin@example.org";
    extraModules = [
      {
        name = "php7";
        path = "${pkgs.php}/modules/libphp7.so";
      }
    ];
  };

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

  # Increase ulimits (mainly for JVM stuff)
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
