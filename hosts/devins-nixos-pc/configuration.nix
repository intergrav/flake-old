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

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.networkmanager.enable = true;
  networking.hostName = "devins-nixos-pc";

  # Time zone
  time.timeZone = "America/Nassau";

  # X11 and GNOME settings
  services.xserver.enable = true;
  services.xserver.excludePackages = [pkgs.xterm];
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
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

  # Fix multi-monitor refresh rates with X11
  environment.sessionVariables = {
    __GL_SYNC_DISPLAY_DEVICE = "DP-0";
  };

  # OpenGL and NVIDIA settings
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;
  };

  # CUPS for printing
  services.printing.enable = true;

  # Sound with Pipewire
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account
  users.users.devin = {
    isNormalUser = true;
    description = "Devin";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable experimental features
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # List packages installed in the system profile
  environment.systemPackages = with pkgs; [
    # Text editing and code versioning tools
    nano
    git
    gh
    (vscode-with-extensions.override {
      vscodeExtensions = with vscode-extensions; [
        vscode-extensions.piousdeer.adwaita-theme
        bbenoist.nix
        kamadorueda.alejandra
      ];
    })

    # Compatibility tools
    bottles

    # System information and configuration tools
    neofetch
    alejandra

    # Command runners and automation tools
    just
    gnumake

    # Messaging and community apps
    (discord.override {
      withOpenASAR = true;
      withVencord = true;
    })
    gtkcord4 # gtk Discord client
    fractal-next

    # Web browsing and media playback tools
    firefox
    vlc
    prismlauncher
    cider

    # Tools for software development
    go

    # GNOME extensions for UX and UI improvement
    gnomeExtensions.appindicator
    gnomeExtensions.alphabetical-app-grid
    gnomeExtensions.clipboard-history
    gnomeExtensions.panel-corners
    gnomeExtensions.rounded-window-corners
  ];

  # NixOS release version
  system.stateVersion = "23.05";
}
