{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
  boot.kernelParams = [
   "nvidia-drm.modeset=1" 
      "nvidia-drm.fbdev=1"
  ];

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  
  networking.wg-quick.interfaces = {
    wg0 = {
      configFile = "/etc/wireguard/wg0.conf";
      autostart = false;
    };
    wg1 = {
      configFile = "/etc/wireguard/wg1.conf";
      autostart = false; 
    };
  };

  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans # Chinese/Japanese/Korean characters
      noto-fonts-color-emoji    # The standard colorful emojis 🍎

      nerd-fonts.jetbrains-mono  
      nerd-fonts.fira-code
      nerd-fonts.symbols-only
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = ["JetBrainsMono Nerd Font Mono" ];       
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };

  networking.hosts = {
    "10.0.0.1" = [
      "registry.driva"
      "argocd.driva"
      "redis.driva"
      "rabbitmq.driva"
      "selenium.driva"
      "proxy-manager.driva"
      "vaultwarden.driva"
      "jenkins.driva"
      "clickstack.driva"
      "tickets.driva"
    ];
    "10.0.0.2" = [
      "postgres.driva"
    ];
    "10.0.2.1" = [
      "n8n-olympus.driva.io"
    ];
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.download-buffer-size = 524288000;
  nixpkgs.config.allowUnfree = true;

  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };
  
  console.keyMap = "us-acentos";

  hardware.graphics.enable = true;

  programs.niri.enable = true;
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
  stdenv.cc.cc.lib
  zlib
  glib
  openssl
  curl
  ];
  
  programs.dconf.enable = true;
  programs.fish.enable = true;

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;

    powerManagement.enable = false;
    powerManagement.finegrained = false;

    open = false;

    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ 
      pkgs.xdg-desktop-portal-gtk 
      pkgs.xdg-desktop-portal-gnome
    ];
    config.common.default = ["gtk"];
    config.niri.default = pkgs.lib.mkForce [ "gnome" "gtk" ]; 
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";               
    _JAVA_AWT_WM_NONREPARENTING = "1";
    XDG_CURRENT_DESKTOP = "Niri"; 
    XDG_SESSION_TYPE = "wayland";

    EDITOR = "nvim";
    VISUAL = "nvim";
    
  };

  services.xserver.enable = false;
  services.displayManager.gdm.enable = false;
  services.desktopManager.gnome.enable = false;

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd niri-session";
        user = "greeter";
      };
    };
  };

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.falabretti = {
    isNormalUser = true;
    description = "falabretti";
    extraGroups = [ "networkmanager" "wheel" "video" "input" ];
    shell = pkgs.fish;
    packages = [ 
    ];
  };

  nixpkgs.overlays = [ inputs.claude-code.overlays.default ];
  environment.systemPackages = with pkgs; [
    # Core CLI
    claude-code
    bash

    # Network
    wireguard-tools
    
    glib
    gsettings-desktop-schemas
  ];

  # System state version
  system.stateVersion = "25.11"; 
}
