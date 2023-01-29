# ============================================================================ #
#
#
#
# ---------------------------------------------------------------------------- #

{ lib }: let

# ---------------------------------------------------------------------------- #

in {

# ---------------------------------------------------------------------------- #

  moduleDropDefaults = submodule: value: let
    subs = submodule.getSubOptions [];
  in lib.filterAttrs ( f: v:
    ( ! ( subs.${f} ? default ) ) || ( v != subs.${f}.default )
  ) value;


# ---------------------------------------------------------------------------- #

}


# ---------------------------------------------------------------------------- #
#
#
#
# ============================================================================ #
