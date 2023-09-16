{
  inputs,
  config,
  pkgs,
  ...
}: {
  # Home Manager needs information about you and paths
  home.username = "devin";
  home.homeDirectory = "/home/devin";

  # List of packages to install for me
  home.packages = with pkgs; [
    nano
    gh
    just
    gnumake
    (vscode-with-extensions.override {
      vscodeExtensions = with vscode-extensions; [
        vscode-extensions.catppuccin.catppuccin-vsc
        bbenoist.nix
        kamadorueda.alejandra
      ];
    })
    neofetch
    alejandra
    firefox
    obsidian
    easyeffects
    (discord.override {
      withVencord = true;
    })
    fractal-next
    filezilla
    vlc
    spotify
    spot
    prismlauncher
    go
    python311
    gnomeExtensions.alphabetical-app-grid
    gnomeExtensions.panel-corners
    gnomeExtensions.rounded-window-corners
    inter
  ];

  # GNOME shell and extension settings
  dconf.settings = {
    "org/gnome/shell" = {
      favorite-apps = [
        "org.gnome.Console.desktop"
        "org.gnome.Nautilus.desktop"
        "firefox.desktop"
        "discord.desktop"
        "spotify.desktop"
        "code.desktop"
        "com.usebottles.bottles.desktop"
      ];
      disable-user-extensions = false;
      enabled-extensions = [
        "AlphabeticalAppGrid@stuarthayhurst"
        "panel-corners@aunetx"
        "rounded-window-corners@yilozt"
      ];
    };
    "org/gnome/nautilus/list-view" = {
      default-folder-viewer = "list-view";
      use-tree-view = true;
    };
    "org/gnome/nautilus/default-zoom-level" = {
      default-folder-viewer = "small";
    };
    "org/gnome/settings-daemon/plugins/power" = {
      power-button-action = "interactive";
      sleeping-inactive-ac-type = "nothing";
    };
    "org/gnome/desktop/background" = {
      picture-uri = "https://raw.githubusercontent.com/NixOS/nixos-artwork/master/wallpapers/nix-wallpaper-nineish.src.svg";
      picture-uri-dark = "https://raw.githubusercontent.com/NixOS/nixos-artwork/master/wallpapers/nix-wallpaper-nineish-dark-gray.svg";
    };
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      enable-hot-corners = false;
      clock-format = "12h";
    };
    "org/gnome/desktop/privacy" = {
      remember-recent-files = false;
      remove-old-temp-files = true;
      remove-old-trash-files = true;
      old-files-age = 2;
    };
    "org/gnome/mutter" = {
      edge-tiling = true;
      dynamic-workspaces = true;
      workspaces-only-on-primary = true;
    };
    "org/gtk/settings/file-chooser" = {
      clock-format = "12h";
      sort-directories-first = true;
    };
  };

  # GTK settings
  gtk.enable = true;
  gtk.theme = {
    name = "adw-gtk3-dark";
    package = pkgs.adw-gtk3;
  };

  # Git settings
  programs.git = {
    enable = true;
    userName = "intergrav";
    userEmail = "intergrav@proton.me";
  };

  # Home Manager release version
  home.stateVersion = "22.11";

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}
