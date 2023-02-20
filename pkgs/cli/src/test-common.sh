#! /usr/bin/env bash
# ============================================================================ #
#
#
#
# ---------------------------------------------------------------------------- #

: "${MKDIR:=mkdir}";
: "${MKTEMP:=mktemp}";

. "${BASH_SOURCE[0]%/*}/common.sh";

# ---------------------------------------------------------------------------- #

echo "SPATH: $SPATH";
echo "SDIR: $SDIR";
echo "_as_me: $_as_me";
echo "system: $( nixSystem; )";


# ---------------------------------------------------------------------------- #

flocoRef;

# ---------------------------------------------------------------------------- #

declare -a TEMPDIRS TEMPFILES;
TEMPDIRS=();
TEMPFILES=();

_ec=0;
trap '
  _ec="$?";
  rm -rf "${TEMPDIRS[@]}" "${TEMPFILES[@]}";
  exit "$_ec";
' EXIT;

(
  TDIR="$( $MKTEMP -d; )";
  TEMPDIRS+=( "$TDIR" );
  cd "$TDIR" >/dev/null;
  echo '{
    inputs.floco.url = "github:aakropotkin/floco";
    outputs = _: {};
  }' > flake.nix;
  $NIX flake lock;
  unset _floco_ref;
  flocoRef;
);

# ---------------------------------------------------------------------------- #
#
#
#
# ============================================================================ #
