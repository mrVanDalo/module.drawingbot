{
  description = "A very basic flake";

  outputs = { self, nixpkgs }: {

    packages.x86_64-linux =
      with import nixpkgs { system = "x86_64-linux"; };
      let

        dontUnpack = true;
        buildPhase = ''
          dpkg -x $src unpacked
          mkdir -p $out
          cp -r unpacked/opt/drawingbotv3/* $out/
        '';
        nativeBuildInputs = [ pkgs.dpkg ];
        version = "1.6.25-stable";

        fhsPackages = import ./fhsPackages.nix;
        fhsEnvironmentBuilder =
          { pkgs
          , drawbotPackage
          , runScript
          }:
          buildFHSEnv {
            name = runScript;
            inherit (fhsPackages) multiPkgs;
            inherit runScript;
            targetPkgs = pkgs: with pkgs; [
              #self.packages.x86_64-linux.drawingbot_bin_premium
              drawbotPackage
              zenity
            ] ++ fhsPackages.commonTargetPkgs pkgs;
          };

      in
      {

        default = self.packages.x86_64-linux.drawingbot_bin_free;

        drawingbot_deb_premium =
          stdenv.mkDerivation rec {
            name = "drawingbot_bin_premium";
            inherit dontUnpack buildPhase nativeBuildInputs version;
            src = pkgs.requireFile {
              name = "DrawingBotV3-Premium-${version}-linux-x86-64.deb";
              url = "https://drawingbotv3.com/releases/";
              sha256 = "1djcmd0bi46insmx1b1swh1m98gv0yl7yg38b53m9kw522y9djrw";
            };
          };

        drawingbot_bin_premium = fhsEnvironmentBuilder {
          inherit pkgs;
          drawbotPackage = self.packages.x86_64-linux.drawingbot_deb_premium;
          runScript = "DrawingBotV3-Premium";
        };

        drawingbot_deb_free =
          stdenv.mkDerivation rec {
            name = "drawingbot_bin_free";
            inherit dontUnpack buildPhase nativeBuildInputs version;
            src = pkgs.fetchurl {
              url = "https://github.com/SonarSonic/DrawingBotV3/releases/download/v${version}-free/DrawingBotV3-Free-${version}-linux.deb";
              sha256 = "sha256-4/N0ma82fz7A/iWt0FJ6NTskdlXiCjdqTlLXLlnUfNw=";
            };
          };

        drawingbot_bin_free = fhsEnvironmentBuilder {
          inherit pkgs;
          drawbotPackage = self.packages.x86_64-linux.drawingbot_deb_free;
          runScript = "DrawingBotV3-Free";
        };

      };

  };
}
