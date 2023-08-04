alias sw := switch
alias up := update

switch:
  sudo nixos-rebuild switch --flake .

update:
  sudo nix flake update --commit-lock-file