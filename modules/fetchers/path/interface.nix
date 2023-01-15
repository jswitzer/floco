# ============================================================================ #
#
# Arguments used to fetch a source tree or file.
#
# ---------------------------------------------------------------------------- #

{ lib, ... }: let

# ---------------------------------------------------------------------------- #

  nt = lib.types;
  ft = import ../../fetchInfo/types.nix { inherit lib; };

# ---------------------------------------------------------------------------- #

in {

  options.path = lib.mkOption {
    description = lib.mdDoc "`builtins.path` fetcher";
    type        = nt.submodule {
      options.fetchInfo = nt.submodule {
        options = {
          name   = lib.mkOption { type = nt.str; default = "source"; };
          path   = lib.mkOption { type = nt.path; };
          filter = lib.mkOption {
            type    = nt.functionTo ( nt.functionTo nt.bool );
            default = name: type: true;
          };
          recursive = lib.mkOption { type = nt.bool; default = true; };
        };
    };
  };

}


# ---------------------------------------------------------------------------- #
#
#
#
# ============================================================================ #
