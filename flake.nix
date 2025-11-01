{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # If using a stable channel you can use `url = "github:nix-community/nixvim/nixos-<version>"`
    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";

    wrappers.url = "github:lassulus/wrappers";
    wrappers.inputs.nixpkgs.follows = "nixpkgs";

    globset.url = "github:pdtpartners/globset";
  };

  outputs = {
    flake-utils,
    globset,
    nixpkgs,
    nixvim,
    ...
  } @ inputs: let
    gnome' = {...}: {
      services = {
        displayManager.gdm.enable = true;
        desktopManager.gnome.enable = true;
      };

      # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
      systemd.services."getty@tty1".enable = false;
      systemd.services."autovt@tty1".enable = false;

      hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
        settings = {
          General = {
            Experimental = true;
          };
        };
      };

      # Bootloader.
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      networking.hostName = "nixos"; # Define your hostname.
      # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

      # Configure network proxy if necessary
      # networking.proxy.default = "http://user:password@proxy:port/";
      # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

      # Enable networking
      networking.networkmanager.enable = true;

      # Configure keymap in X11
      services.xserver.xkb = {
        layout = "au";
        variant = "";
      };

      # Enable CUPS to print documents.
      services.printing.enable = true;

      # Enable sound with pipewire.
      services.pulseaudio.enable = false;
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        # If you want to use JACK applications, uncomment this
        #jack.enable = true;

        # use the example session manager (no others are packaged yet so this is enabled by default,
        # no need to redefine it in your config for now)
        #media-session.enable = true;
      };

      # Enable touchpad support (enabled default in most desktopManager).
      services.libinput.enable = true;
    };

    locale' = {
      # Set your time zone.
      time.timeZone = "Australia/Melbourne";

      # Select internationalisation properties.
      i18n.defaultLocale = "en_AU.UTF-8";

      i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_AU.UTF-8";
        LC_IDENTIFICATION = "en_AU.UTF-8";
        LC_MEASUREMENT = "en_AU.UTF-8";
        LC_MONETARY = "en_AU.UTF-8";
        LC_NAME = "en_AU.UTF-8";
        LC_NUMERIC = "en_AU.UTF-8";
        LC_PAPER = "en_AU.UTF-8";
        LC_TELEPHONE = "en_AU.UTF-8";
        LC_TIME = "en_AU.UTF-8";
      };
    };

    system' = {pkgs, ...}: {
      # Realtime kernel
      # boot.kernelPackages = pkgs.linuxPackages-rt;

      # Enable automatic login for the user.
      services.displayManager.autoLogin.enable = true;
      services.displayManager.autoLogin.user = "waynevanson";

      nix.settings = {
        # enable flakes
        experimental-features = ["nix-command" "flakes"];

        # enable cachix caches
        substituters = [
          "https://nix-community.cachix.org"
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
      };

      # don't change this unless on a new system.
      system.stateVersion = "25.05";
    };

    # user level packages
    waynevanson' = {pkgs, ...}: let
      dotfiles' = pkgs.writeShellScriptBin "dotfiles" (builtins.readFile ./dotfiles.sh);
      # Workaround for https://github.com/NixOS/nixpkgs/issues/446226
      bitwig' = pkgs.bitwig-studio.override {
        bitwig-studio-unwrapped = pkgs.bitwig-studio5-unwrapped.overrideAttrs rec {
          version = "5.0.11";
          src = pkgs.fetchurl {
            name = "bitwig-studio-${version}.deb";
            url = "https://downloads.bitwig.com/${version}/bitwig-studio-${version}.deb";
            hash = "sha256-c9bRWVWCC9hLxmko6EHgxgmghrxskJP4PQf3ld2BHoY=";
          };
        };
      };
      packages = with pkgs; [
        alejandra
        bitwig'
        curl
        direnv
        discord
        dotfiles'
        git
        gnutar
        nerd-fonts.jetbrains-mono
        neofetch
        nfs-utils
        nil
        openscad
        prusa-slicer
        runelite
        tuckr
        unzip
        wget
        vscode.fhs
        xz
        zip
      ];
    in {
      programs.firefox.enable = true;
      programs.direnv.enable = true;

      # Define a user account. Don't forget to set a password with ‘passwd’.
      users.users.waynevanson = {
        isNormalUser = true;
        description = "Wayne Van Son";
        extraGroups = ["audio" "video" "networkmanager" "wheel"];
        inherit packages;
      };
    };

    cursor' = {pkgs, ...}: {
      environment.systemPackages = with pkgs; [
        bibata-cursors
      ];

      environment.sessionVariables = {
        XCURSOR_THEME = "Bibata-Classic-Ice";
        XCURSOR_SIZE = "24";
      };
    };

    # todo: add ohmyposh
    zsh' = {
      programs.zsh = {
        enable = true;
        enableCompletion = true;
        enableBashCompletion = true;
        enableLsColors = true;
      };
    };

    docker' = {pkgs, ...}: {
      virtualisation.docker.enable = true;
      users.users.waynevanson.extraGroups = ["docker"];
      environment.systemPackages = with pkgs; [
        docker
        docker-compose
      ];
    };

    nfs' = {
      services.gvfs.enable = true;
      fileSystems."/mnt/nas" = {
        device = "192.168.1.103:/mnt/storage_pool_0/nextcloud/user";
        fsType = "nfs";
        options = ["x-systemd.automount" "x-systemd.idle-timeout=600" "noauto"];
      };
      boot.supportedFilesystems = ["nfs"];
    };

    createDefaultExports = dir: let
      files = builtins.readDir dir;
      nixFiles =
        builtins.filter
        (name: name != "default.nix" && builtins.match ".*\\.nix" name != null)
        (builtins.attrNames files);
      imports = map (name: dir + "/${name}") nixFiles;
    in {inherit imports;};
  in
    flake-utils.lib.eachDefaultSystemPassThrough (system: let
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit pkgs system;

        specialArgs = {
          inherit inputs createDefaultExports;
        };

        modules = [
          ./hardware-configuration/${"ThinkPad P16v Gen 1"}/hardware-configuration.nix
          nixvim.nixosModules.nixvim
          cursor'
          docker'
          gnome'
          locale'
          system'
          waynevanson'
          zsh'
          ./nix
        ];
      };
    });
}
