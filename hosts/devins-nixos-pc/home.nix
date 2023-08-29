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
      withOpenASAR = true;
      withVencord = true;
    })
    filezilla
    vlc
    spotify
    spicetify-cli
    prismlauncher-qt5
    go
    inter
  ];

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
