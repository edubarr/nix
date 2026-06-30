{ pkgs, ... }:
let
  opencodeBaseline = pkgs.stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "opencode-linux-x64-baseline";
    version = "1.17.9";

    src = pkgs.fetchurl {
      url = "https://registry.npmjs.org/opencode-linux-x64-baseline/-/opencode-linux-x64-baseline-${finalAttrs.version}.tgz";
      hash = "sha256-gIxWb7kqDR8udVBZ6jJdH4jNDc7XRhcNGgPKxVvqHuk=";
    };

    sourceRoot = "package";
    dontConfigure = true;
    dontBuild = true;

    nativeBuildInputs = [
      pkgs.makeWrapper
      pkgs.patchelf
    ];

    installPhase = ''
      runHook preInstall

      install -Dm755 bin/opencode $out/bin/opencode
      patchelf \
        --set-interpreter ${pkgs.glibc}/lib/ld-linux-x86-64.so.2 \
        --set-rpath ${pkgs.lib.makeLibraryPath [ pkgs.glibc ]} \
        $out/bin/opencode

      wrapProgram $out/bin/opencode \
        --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.ripgrep ]} \
        --set OPENCODE_DISABLE_AUTOUPDATE true

      runHook postInstall
    '';

    meta = {
      description = "AI coding agent built for the terminal";
      homepage = "https://opencode.ai";
      license = pkgs.lib.licenses.mit;
      mainProgram = "opencode";
      platforms = [ "x86_64-linux" ];
    };
  });
in
{
  environment.systemPackages = [
    pkgs.tmux
    opencodeBaseline
  ];

  programs.nix-ld = {
    enable = true;
  };
}
