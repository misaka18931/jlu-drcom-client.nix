{ lib, stdenv,
  hostname ? "nixos-host",
  debug ? true,
}:

stdenv.mkDerivation rec {
  name = pname;
  pname = "jlu-drcom-client";
  src = ./src;
  buildPhase = ''
    substituteInPlace config.h \
    --replace-fail '{HOSTNAME}' "${hostname}" \
    --replace-fail '{OSINFO}' "$(uname -mo)" \
    --replace-fail '{DEBUG}' "${if debug then "1" else "0"}"
    make
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp jlu-drcom-client $out/bin/
  '';
  meta = with lib; {
    description = "JLU Net Authentication Client";
    longDescription = ''
      Net Authentication Client for JiLin University as a NixOS module.
      ported from github:AndrewLawrence80/jlu-drcom-client
    '';
    mainProgram = "jlu-drcom-client";
    homepage = "https://github.com/misaka18931/jlu-drcom-client.nix";
    license = licenses.gpl3Plus;
    maintainers = [ "misaka18931" ];
    platforms = platforms.all;
  };
}
