alias sw := switch
alias up := update

switch:
  sudo nixos-rebuild switch --flake .

update:
  nix flake update --commit-lock-file