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
    extraSpecialArgs = {inherit inputs pkgs;};
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

  # Power management
  powerManagement.cpuFreqGovernor = "ondemand";

  # Storage things
  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 4d";
  };

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
    NIXOS_OZONE_WL = "1";
  };

  # OpenGL and NVIDIA settings
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
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
    extraGroups = ["networkmanager" "wheel"];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable experimental features
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # NixOS release version
  system.stateVersion = "23.05";
}
