{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
  };

  outputs = {
    flake-utils,
    nixpkgs,
    ...
  } @ inputs: let
    gnome' = {...}: {
      services.xserver = {
        displayManager.gdm.enable = true;
        desktopManager.gnome.enable = true;
      };

      # Enable automatic login for the user.
      services.displayManager.autoLogin.enable = true;
      services.displayManager.autoLogin.user = "waynevanson";

      # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
      systemd.services."getty@tty1".enable = false;
      systemd.services."autovt@tty1".enable = false;

      nix.settings = {
        experimental-features = ["nix-command" "flakes"];
        substituters = [
          "https://nix-community.cachix.org"
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
      };

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
      services.xserver.libinput.enable = true;

      system.stateVersion = "25.05";
    };
    # user level packages
    waynevanson' = {pkgs, ...}: let
      dotfiles' = pkgs.writeShellScriptBin "dotfiles" (builtins.readFile ./dotfiles.sh);
      packages = with pkgs; [
        alacritty
        alejandra
        curl
        direnv
        discord
        dotfiles'
        git
        gnutar
        nerd-fonts.jetbrains-mono
        neofetch
        nil
        podman
        podman-desktop
        podman-compose
        podman-tui
        prusa-slicer
        tuckr
        unzip
        volta
        wget
        vscode.fhs
        xz
        zip
      ];
    in {
      programs.firefox.enable = true;

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
        XCURSOR_SIZE = "32";
      };
    };

    zsh' = {
      programs.zsh = {
        enable = true;
        enableCompletion = true;
        enableBashCompletion = true;
        enableLsColors = true;
      };
    };

    podman' = {pkgs, ...}: {
      virtualisation = {
        containers.enable = true;
        podman = {
          enable = true;
          dockerCompat = true;
          defaultNetwork.settings.dns_enabled = true;
        };
      };
    };

    neovim' = {
      programs.neovim = {
        enable = true;
        viAlias = true;
        vimAlias = true;
        defaultEditor = true;
      };
    };

    rust' = {
      pkgs,
      lib,
      ...
    }: {
      environment.systemPackages = with pkgs; [
        clang
        llvmPackages.bintools
        probe-rs-tools
        rustup
      ];

      environment.sessionVariables = {
        BINDGEN_EXTRA_CLANG_ARGS =
          lib.concatStringsSep " "
          (builtins.map builtins.toString (
            (builtins.map (a: ''-I"${a}/include"'') [
              pkgs.glibc.dev
            ])
            ++ [
              ''-I"${pkgs.llvmPackages_latest.libclang.lib}/lib/clang/${pkgs.llvmPackages_latest.libclang.version}/include"''
              ''-I"${pkgs.glib.dev}/include/glib-2.0"''
              ''-I${pkgs.glib.out}/lib/glib-2.0/include/''
            ]
          ));
        LIBCLANG_PATH = pkgs.lib.makeLibraryPath [pkgs.llvmPackages_latest.libclang.lib];
      };

      environment.shellInit = ''
        export PATH="$PATH:~/.volta/bin"
      '';
    };
  in
    flake-utils.lib.eachDefaultSystemPassThrough (system: {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;

        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        specialArgs = {inherit inputs;};

        modules = [
          ./hardware-configuration/${"ThinkPad P16v Gen 1"}/hardware-configuration.nix
          gnome'
          podman'
          rust'
          neovim'
          cursor'
          waynevanson'
          zsh'
        ];
      };
    });
}
