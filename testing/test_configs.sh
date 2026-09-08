#!/bin/bash
set -euo pipefail

REPO_URL="https://github.com/agillis/esphome-modular-lvgl-buttons.git"
REPO_DIR="esphome-modular-lvgl-buttons"
EXAMPLE_DIR="$REPO_DIR/example_code"

# Mode: "config" (default) validates YAML only; "compile" also builds the C++.
# `esphome config` never invokes the toolchain, so it cannot catch C++/API-drift
# bugs (e.g. a component calling a removed overload) -- only `esphome compile`
# does. Compiling every config would be slow, so compile mode builds a minimal
# set that still covers every distinct chip family AND every external component:
# a config is compiled only if it introduces a chip variant or an external
# component not already built. This keeps the build count small while ensuring
# each piece of compiled code (which is where API drift bites) is exercised at
# least once -- including components used by only one board (e.g. gsl3680).
MODE="config"

usage() {
  cat <<EOF
Usage: $0 [--compile]

  (no args)   Validate every example config with 'esphome config' (fast).
  --compile   Validate every config, then compile a minimal set of configs that
              together cover every chip family and every external component,
              catching C++/API-drift bugs that 'esphome config' cannot.
  -h, --help  Show this help.
EOF
}

for arg in "$@"; do
  case "$arg" in
    --compile) MODE="compile" ;;
    --config)  MODE="config" ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $arg"; usage; exit 1 ;;
  esac
done

# Check repo directory exists
if [ ! -d "$REPO_DIR" ]; then
  echo "ERROR: $REPO_DIR directory not found!"
  exit 1
fi

# Check example_code directory exists
if [ ! -d "$EXAMPLE_DIR" ]; then
  echo "ERROR: $EXAMPLE_DIR directory not found!"
  exit 1
fi

# Chip family from the variant in the top-level esp32: block of a rendered
# config. Configs with no esp32: block (e.g. the SDL/host target) print nothing.
family_from_rendered() {
  awk '
    /^esp32:/           { in_esp32=1; next }
    /^[^[:space:]]/     { in_esp32=0 }
    in_esp32 && /^[[:space:]]+variant:/ {
      sub(/^[[:space:]]*variant:[[:space:]]*/, "")
      print tolower($0); exit
    }
  '
}

# External component names from the top-level external_components: block of a
# rendered config. Handles both block (`- name`) and inline (`[a, b]`) lists.
comps_from_rendered() {
  awk '
    /^external_components:/ { inext=1; next }
    /^[^[:space:]]/         { inext=0 }
    inext {
      if (match($0, /components:[[:space:]]*\[[^]]*\]/)) {
        s=substr($0,RSTART,RLENGTH); sub(/.*\[/,"",s); sub(/\].*/,"",s); gsub(/,/," ",s)
        n=split(s,a," "); for(i=1;i<=n;i++){gsub(/[[:space:]]/,"",a[i]); if(a[i]!="")print a[i]}
        incomp=0; next
      }
      if ($0 ~ /^[[:space:]]*components:[[:space:]]*$/) { incomp=1; next }
      if (incomp && $0 ~ /^[[:space:]]*-[[:space:]]*/) {
        t=$0; sub(/^[[:space:]]*-[[:space:]]*/,"",t); gsub(/[[:space:]]/,"",t); if(t!="")print t; next
      }
      if (incomp && $0 ~ /^[[:space:]]*[a-z_]+:/) { incomp=0 }
    }'
}

echo ""
echo "========================================="
echo "Testing config files from $EXAMPLE_DIR"
echo "Mode: $MODE"
echo "========================================="
echo ""

# ----------------------------------------------------------------------------
# Pass 1: validate every config with `esphome config` (fast schema check).
# ----------------------------------------------------------------------------
PASS=0
FAIL=0
FAILED_FILES=()

for yaml_file in "$EXAMPLE_DIR"/*.yaml; do
  [ -f "$yaml_file" ] || continue
  basename=$(basename "$yaml_file")

  echo "--- Validating: $basename ---"

  # Copy to the directory containing the repo so include paths resolve
  cp "$yaml_file" "$basename"

  # Run esphome config from here (above the repo)
  if output=$(esphome config "$basename" 2>&1); then
    echo "  PASS"
    ((PASS++)) || true
  else
    echo "  FAIL"
    echo "$output" | sed 's/^/    /'
    ((FAIL++)) || true
    FAILED_FILES+=("$basename")
  fi

  # Clean up the copied file
  rm -f "$basename"
  echo ""
done

echo "========================================="
echo "Config results: $PASS passed, $FAIL failed"
echo "========================================="

# ----------------------------------------------------------------------------
# Pass 2 (compile mode only): compile one representative config per chip family.
# ----------------------------------------------------------------------------
C_PASS=0
C_FAIL=0
COMPILE_FAILED_FILES=()
declare -A COVERED       # coverage token (family:<x> / comp:<x>) -> already built

if [ "$MODE" = "compile" ]; then
  echo ""
  echo "========================================="
  echo "Compiling minimal set covering every chip"
  echo "family and every external component"
  echo "========================================="
  echo ""

  for yaml_file in "$EXAMPLE_DIR"/*.yaml; do
    [ -f "$yaml_file" ] || continue
    basename=$(basename "$yaml_file")

    # Skip configs that already failed validation -- compile would fail too.
    skip=false
    for f in "${FAILED_FILES[@]:-}"; do
      [ "$f" = "$basename" ] && skip=true
    done
    $skip && continue

    cp "$yaml_file" "$basename"

    # Render once, derive the coverage tokens: the chip family plus each
    # external component the config pulls in.
    rendered=$(esphome config "$basename" 2>/dev/null || true)
    # Here-strings, not pipes: family_from_rendered's awk `exit`s at the first
    # match, and a rendered config is far larger than the pipe buffer, so the
    # writer would take SIGPIPE and `set -o pipefail` would abort the run.
    family=$(family_from_rendered <<<"$rendered")
    family=${family:-host}
    tokens=("family:$family")
    while IFS= read -r c; do
      [ -n "$c" ] && tokens+=("comp:$c")
    done < <(comps_from_rendered <<<"$rendered")

    # Compile only if this config introduces a token nothing has covered yet.
    new_tokens=()
    for t in "${tokens[@]}"; do
      [ -z "${COVERED[$t]:-}" ] && new_tokens+=("$t")
    done

    if [ ${#new_tokens[@]} -eq 0 ]; then
      echo "--- Skipping compile: $basename (all coverage already built: ${tokens[*]}) ---"
      rm -f "$basename"
      echo ""
      continue
    fi

    for t in "${tokens[@]}"; do COVERED[$t]=1; done

    echo "--- Compiling: $basename (new coverage: ${new_tokens[*]}) ---"
    if output=$(esphome compile "$basename" 2>&1); then
      echo "  PASS"
      ((C_PASS++)) || true
    else
      echo "  FAIL"
      echo "$output" | tail -40 | sed 's/^/    /'
      ((C_FAIL++)) || true
      COMPILE_FAILED_FILES+=("$basename")
    fi

    rm -f "$basename"
    echo ""
  done

  echo "========================================="
  echo "Compile results: $C_PASS passed, $C_FAIL failed"
  echo "Coverage built: ${!COVERED[*]}"
  echo "========================================="
fi

# ----------------------------------------------------------------------------
# Final summary + exit status.
# ----------------------------------------------------------------------------
if [ ${#FAILED_FILES[@]} -gt 0 ]; then
  echo "Failed config validation:"
  for f in "${FAILED_FILES[@]}"; do
    echo "  - $f"
  done
fi
if [ ${#COMPILE_FAILED_FILES[@]} -gt 0 ]; then
  echo "Failed compilation:"
  for f in "${COMPILE_FAILED_FILES[@]}"; do
    echo "  - $f"
  done
fi

if [ "$FAIL" -gt 0 ] || [ "$C_FAIL" -gt 0 ]; then
  exit 1
fi
