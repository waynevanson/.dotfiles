{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  programs.git = {
    enable = true;
    userName = "Wayne Van Son";
    userEmail = "waynevanson@gmail.com";
  };
}
