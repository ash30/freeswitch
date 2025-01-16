{
  pkgs,
} :
let
  jq = "${pkgs.jq}/bin/jq";
  cc-wrapper-hook = pkgs.writeShellScriptBin "cc-wrapper-hook"  ''
      OUTDB="$(pwd)_$(date +"%s%N").ccdb"
      OUTFILE=""
      INFILE=""

      for ((i=0; i<''${#params[@]}; i++)); do
        case ''${params[$i]} in
          -o)
            if [ $((i+1)) -lt ''${#params[@]} ]; then
              OUTFILE="''${params[$((i + 1))]}"
              OUTDB="$OUTFILE.ccdb"
              OUTFILE="$(realpath $OUTFILE)"
            fi
            ;;
          *.c)
            fle="''${params[$((i))]}"
            if [ -f ''${fle} ]; then
              INFILE=''${fle}
              INFILE="$(realpath $INFILE)"
            fi
            ;;
          esac
      done

      PARAMS=($compiler ''${extraBefore+"''${extraBefore[@]}"} ''${params+"''${params[@]}"} ''${extraAfter+"''${extraAfter[@]}"})
      PARAMS_JSON="$(printf '%s\n' "''${PARAMS[@]}" | ${jq} -R . | jq -s .)"

      jq -n --argjson args "$PARAMS_JSON" --arg directory "$(pwd)" --arg file "$INFILE" --arg output "$OUTFILE" \
      '{
        arguments: $args,
        directory: $directory,
        file: $file,
        output: $output
      }' > $OUTDB
  '';
  cc-hook = ''
    echo "FOOBAR"
    echo ${cc-wrapper-hook}
    echo $out
    ln -s ${cc-wrapper-hook}/bin/cc-wrapper-hook $out/nix-support/cc-wrapper-hook
  '';
  collect-compile-commands = pkgs.writeShellScriptBin "collect-compile-commands" ''
    echo "Collecting compilation commands in current directory."
    find . -type f -name '*.ccdb' -print0 | while IFS= read -r -d $'\0' file; do
      jq -c '.' "$file"
    done | jq -s '.' > compile_commands.json
    echo "Compilation database written to $(realpath compile_commands.json)"
  '';
in pkgs.stdenv.override (old: {
  cc = old.cc.overrideAttrs (final: previous: {
    installPhase = previous.installPhase or "" + cc-hook;
  });
  extraBuildInputs = old.extraBuildInputs or [] ++ [collect-compile-commands];
  allowedRequisites = null;
})
