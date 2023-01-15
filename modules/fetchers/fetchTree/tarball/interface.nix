# ============================================================================ #
#
# Arguments used to fetch a source tree or file.
#
# ---------------------------------------------------------------------------- #

{ lib, ... }: {

  options.fetchTree_tarball = lib.mkOption {
    description = lib.mdDoc "`builtins.fetchTree[tarball]` args";
  };

}


# ---------------------------------------------------------------------------- #
#
#
#
# ============================================================================ #
