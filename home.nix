{
  config,
  pkgs,
  inputs,
  ...
}: {
  # Home Manager needs a bit of information about you and paths.
  home.username = "devin";
  home.homeDirectory = "/home/devin";

  # GNOME and extension settings
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      enable-hot-corners = false;
      clock-format = "12h";
      font-hinting = "slight";
      font-antialiasing = "grayscale";
    };
    "org/gnome/mutter" = {
      edge-tiling = true;
      dynamic-workspaces = true;
      workspaces-only-on-primary = true;
    };
    "org/gnome/shell" = {
      favorite-apps = [
        "org.gnome.Console.desktop"
        "org.gnome.Nautilus.desktop"
        "firefox.desktop"
        "discord.desktop"
        "code.desktop"
      ];
      disable-user-extensions = false;
      enabled-extensions = [
        "AlphabeticalAppGrid@stuarthayhurst"
        "appindicatorsupport@rgcjonas.gmail.com"
        "clipboard-history@alexsaveau.dev"
        "panel-corners@aunetx"
        "rounded-window-corners@yilozt"
        "replaceActivitiesText@pratap.fastmail.fm"
      ];
    };
    "org/gnome/desktop/wm/preferences" = {
      titlebar-font = "Cantarell 11";
    };
    "org/gtk/settings/file-chooser" = {
      clock-format = "12h";
    };
    "org/gnome/shell/extensions/replaceActivitiesText" = {
      icon-path = "/home/devin/Pictures/Backgrounds/nix-snowflake.svg";
      text = "Activities";
      icon-size = 1.05;
    };
  };

  # GTK settings
  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
  };

  # Git settings
  programs.git = {
    enable = true;
    userName = "intergrav";
    userEmail = "intergrav@proton.me";
  };

  # Firefox settings
  home.file.".mozilla/firefox/nix-user-profile/chrome/firefox-gnome-theme".source = inputs.firefox-gnome-theme;

  programs.firefox = {
    enable = true;
    profiles.nix-user-profile = {
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

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "22.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
