{
  config,
  pkgs,
  inputs,
  ...
}:

{
  home.username = "falabretti";
  home.homeDirectory = "/home/falabretti";

  home.stateVersion = "24.11";

  xdg.configFile = {
    "nvim" = {
      source = ./dotfiles/nvim;
      recursive = true;
    };

    "noctalia" = {
      source = ./dotfiles/noctalia;
      recursive = true;
    };

    "fastfetch" = {
      source = ./dotfiles/fastfetch;
      recursive = true;
    };
    "alacritty/alacritty.toml".source = ./dotfiles/alacritty/alacritty.toml;
    "niri/config.kdl".source = ./dotfiles/niri/config.kdl;
    "starship.toml".source = ./dotfiles/starship.toml;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  home.pointerCursor = {
    name = "BreezeX-RosePine-Linux";
    package = pkgs.rose-pine-cursor;
    size = 16;
    gtk.enable = true;
    x11.enable = true;
  };

  home.packages = with pkgs; [
    alacritty
    vesktop
    google-chrome
    jetbrains.datagrip
    inputs.zen-browser.packages.${pkgs.system}.default # Zen from Flake input

    nautilus

    neovim
    git
    wget
    curl
    unzip
    gzip
    tmux
    ripgrep
    fd
    lazygit
    lazydocker
    fastfetch
    gcc
    gnumake
    nodejs_22
    python3
    yarn
    cargo
    rustc
    nixfmt-rfc-style
    statix
    nixd

    wl-clipboard
    grim
    slurp
    libnotify
    mako
    xwayland-satellite
    inputs.noctalia.packages.${pkgs.system}.default # Noctalia from Flake input
  ];

  programs.starship.enable = true;

  programs.fish = {
    enable = true;
    shellAliases = {
      ls = "ls --color=auto";
      grep = "grep --color=auto";
      la = "ls -a";
      lr = "ls -R";

      # Your tools
      vi = "nvim";
      vim = "nvim";
      svi = "sudoedit";
      nix-fish = "nix-shell --command fish";
      claude = "env SHELL=/run/current-system/sw/bin/bash claude";

      rebuild = "sudo nixos-rebuild switch --flake ~/code/nixconf#nixos";
      clean = "nix-collect-garbage -d";
    };

    interactiveShellInit = ''
      set -g fish_greeting ""
      fish_add_path "$HOME/.cargo/bin"

      function mkcd
          mkdir -p $argv[1]
          cd $argv[1]
      end

      clear
      fastfetch
    '';
  };

  programs.home-manager.enable = true;
}
