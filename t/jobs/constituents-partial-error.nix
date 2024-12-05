with import ./config.nix;
{
  pkgs = throw "you shall not pass";
  pkgs2.foo = mkDerivation {
    name = "foobar";
    builder = builtins.toFile "build.sh" ''
      #!/bin/sh
      mkdir $out
    '';
  };

  release = mkDerivation {
    name = "foobar";
    builder = builtins.toFile "build.sh" ''
      #!/bin/sh
      mkdir $out
    '';
    _hydraAggregate = true;
    _hydraGlobConstituents = true;
    constituents = [
      "pkgs.*"
      "pkgs2.*"
    ];
  };
}

