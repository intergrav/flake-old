{
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {
      devin = import ./home.nix;
    };
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable networking
  networking.networkmanager.enable = true;
  networking.hostName = "devins-nixos-pc";

  # Set your time zone.
  time.timeZone = "America/Nassau";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Display Manager.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Exclude XTerm
  services.xserver.excludePackages = [pkgs.xterm];

  # Exclude some GNOME packages
  environment.gnome.excludePackages = with pkgs; [
    gnome-photos
    gnome-tour
    gnome.yelp
    gnome.cheese
    gnome.gnome-music
    gnome.gedit
    gnome.epiphany
    gnome.geary
    gnome.evince
    gnome.gnome-characters
    gnome.totem
    gnome.tali
    gnome.iagno
    gnome.hitori
    gnome.atomix
    gnome.gnome-contacts
    gnome.gnome-maps
    gnome.gnome-calendar
  ];

  environment.sessionVariables = {
    __GL_SYNC_DISPLAY_DEVICE = "DP-0";
  };

  # Make sure OpenGL is enabled
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Tell Xorg to use the nvidia driver (also valid for Wayland)
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    # Modesetting is needed for most Wayland compositors
    modesetting.enable = true;

    # Use the open source version of the kernel module
    # Only available on driver 515.43.04+
    open = false;

    # Enable the nvidia settings menu
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account.
  users.users.devin = {
    isNormalUser = true;
    description = "Devin";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [];
  };

  # Allow unfree packages.
  nixpkgs.config.allowUnfree = true;

  # Experimental features.
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    # CLI, libraries
    nano
    git
    gh
    neofetch
    just
    alejandra

    # Applications
    (vscode-with-extensions.override {
      vscodeExtensions = with vscode-extensions; [
        bbenoist.nix
        kamadorueda.alejandra
      ];
    })
    (discord.override {
      withOpenASAR = true;
      withVencord = true;
    })
    firefox
    vlc
    prismlauncher
    cider

    # Miscellaneous
    gnomeExtensions.appindicator
    gnomeExtensions.alphabetical-app-grid
    gnomeExtensions.clipboard-history
    gnomeExtensions.panel-corners
    gnomeExtensions.rounded-window-corners
    gnomeExtensions.replace-activities-text
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05";
}
