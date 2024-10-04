{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = {nixpkgs, ...}: let
    createModules = user: [
      # docker
      ({
        pkgs,
        lib,
        config,
        ...
      }: {
        users.users.${user}.extraGroups =
          lib.mkMerge [["docker"]];

        # Actually turn it on.
        virtualisation.docker.enable = true;

        # Add the packages.
        environment.systemPackages = with pkgs; [docker docker-compose];
      })

      # steam
      ({
        pkgs,
        lib,
        ...
      }: {
        programs.steam = {
          enable = true;
          remotePlay.openFirewall = true;
          dedicatedServer.openFirewall = true;
          localNetworkGameTransfers.openFirewall = true;
        };
        environment.systemPackages = with pkgs; [
          lutris
          wineWowPackages.stable
          winetricks
        ];
      })

      # Packages
      ({
        pkgs,
        lib,
        ...
      }: let
        bitwig-studio' = pkgs.bitwig-studio.overrideAttrs {
          version = "5.0.11";
          src = pkgs.fetchurl {
            url = "https://www.bitwig.com/dl/Bitwig%20Studio/5.0.11/installer_linux/";
            hash = "sha256-c9bRWVWCC9hLxmko6EHgxgmghrxskJP4PQf3ld2BHoY=";
          };
        };
        vscode' = with pkgs; (vscode-with-extensions.override {
          vscodeExtensions = with vscode-extensions;
            [
              astro-build.astro-vscode
              bbenoist.nix
              dbaeumer.vscode-eslint
              eamodio.gitlens
              esbenp.prettier-vscode
              github.github-vscode-theme
              mkhl.direnv
              ms-vscode-remote.remote-containers
              pkief.material-icon-theme
              pkief.material-product-icons
              redhat.vscode-yaml
              arrterian.nix-env-selector
              rust-lang.rust-analyzer
              tamasfe.even-better-toml
              vscodevim.vim
            ]
            ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
              {
                publisher = "leathong";
                name = "openscad-language-support";
                version = "1.2.5";
                sha256 = "sha256-/CLxBXXdUfYlT0RaGox1epHnyAUlDihX1LfT5wGd2J8=";
              }
            ];
        });
      in {
        environment.systemPackages = with pkgs; [
          bitwig-studio'
          vscode'

          alacritty
          # nix formatter
          alejandra
          chromium
          chromedriver
          corepack
          direnv
          discord
          firefox
          git
          inkscape-with-extensions
          nodejs
          obsidian
          openscad-unstable
          prusa-slicer
          pixelorama
          rar
          signal-desktop
          stow
          unzip
          zip
          zoom-us
        ];
      })

      # X11 & Gnome
      # ({...}:{
      #   # Enable the GNOME Desktop Environment.
      #   services.xserver.desktopManager.gnome.enable = true;
      #   services.xserver.displayManager.gdm.enable = true;

      #   # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
      #   systemd.services."getty@tty1".enable = false;
      #   systemd.services."autovt@tty1".enable = false;

      #   services.xserver.xkb = {
      #     layout = "au";
      #     variant = "";
      #   };
      #   services.xserver.enable = true;
      # })

      # Wayland & Sway
      ({
        pkgs,
        lib,
        ...
      }: let
        config = ''
          # Brightness
          bindsym XF86MonBrightnessDown exec light -U 10
          bindsym XF86MonBrightnessUp exec light -A 10

          # Volume
          bindsym XF86AudioRaiseVolume exec 'pactl set-sink-volume @DEFAULT_SINK@ +1%'
          bindsym XF86AudioLowerVolume exec 'pactl set-sink-volume @DEFAULT_SINK@ -1%'
          bindsym XF86AudioMute exec 'pactl set-sink-mute @DEFAULT_SINK@ toggle'

          # give sway a little time to startup before starting kanshi.
          exec sleep 5; systemctl --user start kanshi.service
        '';
      in {
        # foundation
        environment.systemPackages = with pkgs;
          lib.mkMerge [
            [
              # screenshot functionality
              grim
              # screenshot functionality
              slurp
              # wl-copy & wl-paste for copy paste from stdin/stdout
              wl-clipboard
              # notification system
              mako
            ]
          ];

        # brightness & volume
        users.users.${user}.extraGroups = lib.mkMerge [
          ["video"]
        ];

        # dbus and secrets
        services.gnome.gnome-keyring.enable = true;

        # enable sway wm
        programs.sway = {
          enable = true;
          wrapperFeatures.gtk = true;
        };

        # kanshi systemd service
        systemd.user.services.kanshi = {
          description = "kanshi daemon";
          serviceConfig = {
            Type = "simple";
            ExecStart = ''${pkgs.kanshi}/bin/kanshi -c kanshi_config_file'';
          };
        };

        # allow passwords to work
        security.pam.services.swaylock = {};

        security.pam.loginLimits = [
          {
            domain = "@${user}";
            item = "rtprio";
            type = "-";
            value = 1;
          }
        ];
      })

      # System: languages, hardware & software
      ({
        lib,
        config,
        ...
      }: {
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;
        boot.supportedFilesystems = ["ntfs"];

        networking.networkmanager.enable = true;
        networking.hostName = "nixos";

        time.timeZone = "Australia/Melbourne";

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

        # Enable CUPS to print documents.
        services.printing.enable = true;

        # Enable audio
        hardware.pulseaudio.enable = false;
        security.rtkit.enable = true;
        services.pipewire = {
          enable = true;
          alsa.enable = true;
          alsa.support32Bit = true;
          pulse.enable = true;
        };

        nix.settings.experimental-features = [
          "nix-command"
          "flakes"
        ];

        # systemish

        users.users.${user} = {
          isNormalUser = true;
          description = "Wayne Van Son";

          extraGroups = lib.mkMerge [["networkmanager" "wheel"]];
        };
      })

      # Purely system related
      "/etc/nixos/configuration.nix"

      # Hardware stuff for our actual system.
      "/etc/nixos/hardware-configuration.nix"
    ];

    # utils
    createNixosByHostSystemUser = permutations: constructor:
      builtins.foldl' (accu: {
          host,
          system,
          ...
        } @ permutation:
          accu
          // {
            "${host}" = nixpkgs.lib.nixosSystem (
              {inherit system;} // (constructor permutation)
            );
          }) {}
      permutations;

    hosts = ["nixos"];
    systems = ["x86_64-linux"];
    users = ["waynevanson"];

    permutations = nixpkgs.lib.attrsets.cartesianProduct {
      host = hosts;
      system = systems;
      user = users;
    };
  in {
    nixosConfigurations =
      createNixosByHostSystemUser permutations
      ({
        host,
        system,
        user,
      }: {
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        modules = createModules user;
      });
  };
}
