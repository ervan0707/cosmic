{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "r-auth";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "ervan0707";
    repo = "r-auth";
    rev = "main";
    sha256 = "sha256-57We7vHAseYrNsWdq0tUeYJxh6Q0NOcLgkp41prTI1E=";
  };

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
  };

  meta = with lib; {
    description = "A command-line authentication tool for generating and managing TOTP tokens";
    homepage = "https://github.com/ervan0707/r-auth";
    license = licenses.mit;
  };
}
