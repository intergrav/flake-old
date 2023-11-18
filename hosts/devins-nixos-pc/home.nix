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
    alejandra
    firefox
    obsidian
    easyeffects
    vesktop
    vlc
    spotify
    prismlauncher
    packwiz
    gnomeExtensions.alphabetical-app-grid
    gnomeExtensions.pop-shell
    gnomeExtensions.dash-to-dock
    gnomeExtensions.search-light
    gnomeExtensions.blur-my-shell
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
        "spotify.desktop"
        "code.desktop"
      ];
      disable-user-extensions = false;
      enabled-extensions = [
        "AlphabeticalAppGrid@stuarthayhurst"
        "pop-shell@system76.com"
        "dash-to-dock@micxgx.gmail.com"
        "search-light@icedman.github.com"
        "blur-my-shell@aunetx"
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
    "org/gnome/shell/extensions/dash-to-dock" = {
      extend-height = true;
      dash-max-icon-size = 32;
      dock-position = "LEFT";
      custom-background-color = true;
      dock-fixed = true;
    };
    "org/gnome/shell/extensions/search-light" = {
      border-radius = 3.5;
      border-thickness = 1;
    };
    "org/gnome/shell/extensions/blur-my-shell/applications" = {
      blur = false;
    };
    "org/gnome/shell/extensions/pop-shell" = {
      stacking-with-mouse = false;
    };
  };

  # Add Firefox GNOME theme
  home.file.".mozilla/firefox/do016t03.default/chrome".source = inputs.firefox-gnome-theme;

  programs.firefox.profiles."do016t03.default" = {
    settings = {
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true; # Enable customChrome.cs
      "browser.uidensity" = 0; # Set UI density to normal
      "svg.context-properties.content.enabled" = true; # Enable SVG context-propertes
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
