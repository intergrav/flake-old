{
  inputs,
  config,
  pkgs,
  nixpkgs,
  lib,
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

  # Temporarily permitted insecure packages
  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.plymouth.enable = true;

  # Latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Networking
  networking.networkmanager.enable = true;
  networking.hostName = "devins-nixos-pc";

  # Nix settings - garbage collection, auto optimize store, etc
  nix = {
    gc = {
      automatic = true;
      dates = "03:15";
      options = "-d 3d";
    };
    settings = {
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes"];
    };
  };

  # Time zone
  time.timeZone = "America/Nassau";

  # X11 and GNOME settings
  services.xserver.enable = true;
  services.xserver.excludePackages = [pkgs.xterm];
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome.yelp
    gnome.epiphany
  ];

  # Fix multi-monitor refresh rates with X11
  environment.sessionVariables = {
    __GL_SYNC_DISPLAY_DEVICE = "DP-0";
    NIXOS_OZONE_WL = "1";
    QT_STYLE_OVERRIDE = "kvantum";
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

  # Virtualization
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

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

  # Enable flatpak
  services.flatpak.enable = true;

  # Define a user account
  users.users.devin = {
    isNormalUser = true;
    extraGroups = ["networkmanager" "wheel" "libvirtd"];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # NixOS release version
  system.stateVersion = "23.05";
}
