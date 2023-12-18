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
        piousdeer.adwaita-theme
        bbenoist.nix
        kamadorueda.alejandra
      ];
    })
    alejandra
    obsidian
    easyeffects
    vlc
    steam
    obs-studio
    prismlauncher-qt5
    r2modman
    packwiz
    libsForQt5.qtstyleplugin-kvantum
    qt6Packages.qtstyleplugin-kvantum
    gnomeExtensions.appindicator
    gnomeExtensions.alphabetical-app-grid
    gnomeExtensions.rounded-window-corners
    gnomeExtensions.pop-shell
  ];

  # GNOME shell and extension settings
  dconf.settings = {
    "org/gnome/shell" = {
      favorite-apps = [
        "org.gnome.Console.desktop"
        "org.gnome.Nautilus.desktop"
        "firefox.desktop"
        "code.desktop"
        "steam.desktop"
      ];
      disable-user-extensions = false;
      enabled-extensions = [
        "appindicatorsupport@rgcjonas.gmail.com"
        "AlphabeticalAppGrid@stuarthayhurst"
        "rounded-window-corners@yilozt.shell-extension"
        "pop-shell@system76.com"
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
    "org/gnome/desktop/wm/preferences" = {
      titlebar-font = "Cantarell 11";
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
    "org/gnome/shell/extensions/pop-shell" = {
      stacking-with-mouse = false;
    };
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
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

  # Firefox GNOME theme
  home.file.".mozilla/firefox/do016t03.default/chrome/firefox-gnome-theme".source = inputs.firefox-gnome-theme;

  programs.firefox = {
    enable = true;
    profiles."do016t03.default" = {
      userChrome = ''
        @import "firefox-gnome-theme/userChrome.css";
      '';
      userContent = ''
        @import "firefox-gnome-theme/userContent.css";
      '';
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.uidensity" = 0;
        "svg.context-properties.content.enabled" = true;
        "browser.theme.dark-private-windows" = false;
      };
    };
  };

  # Home Manager release version
  home.stateVersion = "22.11";

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}
