{
  description = "A very basic flake";

  outputs = { self, nixpkgs }: {

    packages.x86_64-linux.drawingbot_bin =
      with import nixpkgs { system = "x86_64-linux"; };
      stdenv.mkDerivation rec {
        name = "drawingbot";
        dontUnpack = true;
        buildPhase = ''
          dpkg -x $src unpacked
          mkdir -p $out
          cp -r unpacked/opt/drawingbotv3/* $out/
        '';
        nativeBuildInputs = [ pkgs.dpkg ];
        version = "1.6.1-beta";
        src = pkgs.requireFile {
          name = "DrawingBotV3-Premium-${version}-linux.deb";
          url = "https://drawingbotv3.com/releases/";
          sha256 = "04x477azqdj3dc66wnjia44cnkp7nsba40a3qh0fhghprl4y41kk";
        };
      };

    packages.x86_64-linux.drawingbot =
      with import nixpkgs { system = "x86_64-linux"; };
      pkgs.writers.writeDashBin "drawingbot" ''
        ${pkgs.steam}/bin/steam-run ${self.packages.x86_64-linux.drawingbot_bin}/bin/DrawingBotV3
      '';

    packages.x86_64-linux.default = self.packages.x86_64-linux.drawingbot_bin;

  };
}
