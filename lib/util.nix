# ============================================================================ #
#
#
#
# ---------------------------------------------------------------------------- #

{ lib }: let

# ---------------------------------------------------------------------------- #

  libLoc    = "floco#lib.libfloco";
  throwFrom = fn: msg: throw "${libLoc}.${fn}: ${msg}";

# ---------------------------------------------------------------------------- #

  depPinsToKeys = x: let
    depInfo = x.depInfo or x;
    deToKey = dIdent: { pin ? throwFrom "depPinsToKeys" "pin not found", ... }:
      "${dIdent}/${pin}";
  in builtins.mapAttrs deToKey depInfo;


# ---------------------------------------------------------------------------- #

  depPinsToDOT = {
    depInfo ? {}
  , key     ? ident + "/" + version
  , ident
  , version
  , ...
  } @ pdef: let
    toDOT = _: depKey: "  " + ''"${depKey}" -> "${key}";'';
  in builtins.attrValues ( builtins.mapAttrs toDOT ( depPinsToKeys pdef ) );


  pdefsToDOT = {
    graphName ? "flocoPackages"
  , pdefs     ? {}
  }: let
    pdefsL = if builtins.isList pdefs then pdefs else
             lib.collect ( v: v ? _export ) pdefs;
    dot    = builtins.concatMap depPinsToDOT pdefsL;
    header = ''
      digraph ${graphName} {
    '';
  in header + ( builtins.concatStringsSep "\n" dot ) + "\n}";


# ---------------------------------------------------------------------------- #

  show       = s: builtins.trace ( "\n" + s + "\n" ) null;
  showPretty = x: show ( lib.generators.toPretty {} x );

  showPrettyCurried = x:
    if ! ( builtins.isFunction x ) then showPretty x else
    y: showPrettyCurried ( x y );


# ---------------------------------------------------------------------------- #

  prettyPrintEscaped = let
    escapeKeywords = let
      keywords = [
        "assert"
        "throw"
        "with"
        "let"
        "in"
        "or"
        "inherit"
        "rec"
        "import"
      ];
      froms = map ( k: " ${k} = " ) keywords;
      tos   = map ( k: " \"${k}\" = " ) keywords;
    in builtins.replaceStrings froms tos;
  in e: ( escapeKeywords ( lib.generators.toPretty {} e ) ) + "\n";


# ---------------------------------------------------------------------------- #

  # Helper used by various routines to apply a function to an attrset of
  # `config.floco.<FIELD>.<NAME>.<VERSION>'.
  # Most commonly used to apply functions to `pdefs' and `packages'.
  runNVFunction = {
    field  ? "pdefs"
  , modify ? true    # Whether the returned value should maintain the same
                     # attrset hierarchy as the input ( performing an update ).
                     # If false, the return value is the result of the function.
  , fn
  }: {
    __functionArgs = {
      config   = true;
      floco    = true;
      ${field} = true;
    };
    __functor = _: args: let
      config = args.config or { floco.${field} = args; };
      floco  = args.floco or config.floco;
      value  = floco.${field};
    in ka: let
      k = if builtins.isAttrs ka then ka else
          assert builtins.isString ka;
          { key = ka; };
      rsl    = fn value k;
      forMod =
        if args ? config then { config.floco.${field} = rsl; } else
        if args ? floco  then { floco.${field} = rsl; } else
        if args ? ${field}  then { ${field} = rsl; } else
        rsl;
    in if modify then forMod else rsl;
  };



# ---------------------------------------------------------------------------- #

in {

  inherit
    depPinsToKeys
    depPinsToDOT
    pdefsToDOT

    show showPretty showPrettyCurried

    prettyPrintEscaped

    runNVFunction
  ;

  spp = showPrettyCurried;

}


# ---------------------------------------------------------------------------- #
#
#
#
# ============================================================================ #
