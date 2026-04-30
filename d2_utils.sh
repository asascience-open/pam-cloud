#!/usr/bin/env bash
# d2_utils.sh — D2 diagram utilities
#
# Provides four commands for working with D2 diagrams:
#   compile     Compile a single .d2 file to docs/images/
#   compile-all Compile every .d2 in docs/diagrams/ to docs/images/
#   fmt         Validate and reformat a .d2 file in place
#   watch       Watch a .d2 file and serve a live preview in the browser
#
# Theme, layout, and dark-theme are read from D2 environment variables and
# can be overridden per-invocation with --theme, --dark-theme, and --layout.
#
# ── Project directory structure ─────────────────────────────────────────────────
#
#  PROJ_DIR/          <- this script lives here
#  ├── docs/
#  │   ├── diagrams/  <- project-specific *.d2 source files
#  │   └── images/    <- compiled output: *.svg, *.pdf, *.png
#  └── .vscode/       <- VSCode integration files
#      ├── templates/     <- *.d2 template files
#
# ────────────────────────────────────────────────────────────────────────────────

set -euo pipefail

# ── Paths ──────────────────────────────────────────────────────────────────────
PROJ_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DIAGRAMS_DIR="${PROJ_DIR}/docs/architecture/diagrams"
IMAGES_DIR="${PROJ_DIR}/docs/architecture/images"

# ── D2 defaults (overridden by env vars, further overridden by CLI flags) ──────
D2_LAYOUT="${D2_LAYOUT:-tala}"
D2_THEME="${D2_THEME:-0}"
D2_DARK_THEME="${D2_DARK_THEME:-0}"

# ── Usage ──────────────────────────────────────────────────────────────────────
usage() {
    cat <<EOF
d2_utils.sh — D2 diagram utilities

  Diagrams : ${DIAGRAMS_DIR}
  Images   : ${IMAGES_DIR}

USAGE
  $(basename "${BASH_SOURCE[0]}") <command> [options]

COMMANDS
  compile <file.d2> [fmt]
      Compile a single diagram to ${IMAGES_DIR}/.
      Supported formats: svg (default), png, pdf, all.
      'all' generates svg, png, and pdf in one run.

      Examples:
        $(basename "${BASH_SOURCE[0]}") compile docs/diagrams/arch.d2
        $(basename "${BASH_SOURCE[0]}") compile docs/diagrams/arch.d2 all
        $(basename "${BASH_SOURCE[0]}") compile docs/diagrams/arch.d2 png --theme 101

  compile-all [fmt]
      Compile every *.d2 file found under ${DIAGRAMS_DIR}/ into ${IMAGES_DIR}/.
      Same format options as compile (default: svg).

      Examples:
        $(basename "${BASH_SOURCE[0]}") compile-all
        $(basename "${BASH_SOURCE[0]}") compile-all pdf --layout dagre

  fmt <file.d2>
      Validate and reformat a diagram file in place using 'd2 fmt'.
      Exits non-zero and prints errors if the file has syntax problems.

      Example:
        $(basename "${BASH_SOURCE[0]}") fmt docs/diagrams/arch.d2

  watch <file.d2>
      Watch a diagram file for changes and serve a live preview.
      D2's built-in watch server opens a browser tab automatically.
      Always outputs to ${IMAGES_DIR}/<name>.svg.
      Press Ctrl+C to stop.

      Example:
        $(basename "${BASH_SOURCE[0]}") watch docs/diagrams/arch.d2

OPTIONS  (apply to compile, compile-all, and watch)
  --layout     <engine>   Layout engine: elk (default), dagre, tala
                          Current: ${D2_LAYOUT}
  --theme      <id>       Light theme numeric ID
                          Current: ${D2_THEME}
  --dark-theme <id>       Dark theme numeric ID
                          Current: ${D2_DARK_THEME}

ENVIRONMENT VARIABLES
  D2_LAYOUT, D2_THEME, D2_DARK_THEME
      Set project-wide defaults. Per-invocation flags override these for a
      single run without changing your environment.
EOF
}

# ── Argument parser (populates: layout, theme, dark_theme, format) ─────────────
parse_common_opts() {
    # Callers set these before calling; we only override if flags appear.
    layout="${D2_LAYOUT}"
    theme="${D2_THEME}"
    dark_theme="${D2_DARK_THEME}"
    format="svg"

    while [[ $# -gt 0 ]]; do
        case $1 in
            --layout)     layout="$2";     shift 2 ;;
            --theme)      theme="$2";      shift 2 ;;
            --dark-theme) dark_theme="$2"; shift 2 ;;
            --format)     format="$2";     shift 2 ;;
            # Positional: if it looks like a format word, treat it as --format
            svg|png|pdf|all) format="$1";  shift   ;;
            *) echo "Unknown option: $1" >&2; usage; exit 1 ;;
        esac
    done
}

# ── Internal: compile one file to one format ───────────────────────────────────
compile_one() {
    local file="$1"
    local fmt="$2"
    local out="${IMAGES_DIR}/$(basename "${file}" .d2).${fmt}"
    d2 --layout "${layout}" --theme "${theme}" --dark-theme "${dark_theme}" \
        "${file}" "${out}"
}

# ── validate_d2_file: shared input validation ──────────────────────────────────
validate_d2_file() {
    local file="$1"
    if [[ ! -f "${file}" ]]; then
        echo "Error: file not found: ${file}" >&2; exit 1
    fi
    if [[ "${file}" != *.d2 ]]; then
        echo "Warning: '${file}' does not have a .d2 extension" >&2
    fi
}

# ── compile ────────────────────────────────────────────────────────────────────
cmd_compile() {
    local file="${1:-}"
    if [[ -z "${file}" ]]; then
        echo "Error: compile requires a .d2 file argument" >&2; usage; exit 1
    fi
    shift
    parse_common_opts "$@"
    validate_d2_file "${file}"
    mkdir -p "${IMAGES_DIR}"

    if [[ "${format}" == "all" ]]; then
        for fmt in svg png pdf; do
            echo "Compiling ${fmt}: ${IMAGES_DIR}/$(basename "${file}" .d2).${fmt}"
            compile_one "${file}" "${fmt}"
        done
    else
        echo "Compiling ${format}: ${IMAGES_DIR}/$(basename "${file}" .d2).${format}"
        compile_one "${file}" "${format}"
    fi
}

# ── compile-all ────────────────────────────────────────────────────────────────
cmd_compile_all() {
    parse_common_opts "$@"
    mkdir -p "${IMAGES_DIR}"

    if [[ ! -d "${DIAGRAMS_DIR}" ]]; then
        echo "Error: diagrams directory not found: ${DIAGRAMS_DIR}" >&2; exit 1
    fi

    local ok=0 fail=0
    while IFS= read -r file; do
        local formats_to_run=()
        if [[ "${format}" == "all" ]]; then
            formats_to_run=(svg png pdf)
        else
            formats_to_run=("${format}")
        fi

        for fmt in "${formats_to_run[@]}"; do
            if compile_one "${file}" "${fmt}"; then
                echo "  OK   ${file} -> $(basename "${file}" .d2).${fmt}"
                ((ok++)) || true
            else
                echo "  FAIL ${file}" >&2
                ((fail++)) || true
            fi
        done
    done < <(find "${DIAGRAMS_DIR}" -name '*.d2' -type f | sort)

    echo ""
    echo "Done: ${ok} succeeded, ${fail} failed."
    [[ "${fail}" -eq 0 ]]
}

# ── fmt ────────────────────────────────────────────────────────────────────────
cmd_fmt() {
    local file="${1:-}"
    if [[ -z "${file}" ]]; then
        echo "Error: fmt requires a .d2 file argument" >&2; usage; exit 1
    fi
    validate_d2_file "${file}"
    d2 fmt "${file}"
    echo "Formatted: ${file}"
}

# ── watch ──────────────────────────────────────────────────────────────────────
cmd_watch() {
    local file="${1:-}"
    if [[ -z "${file}" ]]; then
        echo "Error: watch requires a .d2 file argument" >&2; usage; exit 1
    fi
    shift
    parse_common_opts "$@"
    validate_d2_file "${file}"
    mkdir -p "${IMAGES_DIR}"

    local out="${IMAGES_DIR}/$(basename "${file}" .d2).svg"
    echo "Watching: ${file}"
    echo "Output:   ${out}"
    echo "Press Ctrl+C to stop."
    exec d2 --watch --layout "${layout}" --theme "${theme}" \
        --dark-theme "${dark_theme}" "${file}" "${out}"
}

# ── Dispatch ───────────────────────────────────────────────────────────────────
command="${1:-}"
shift || true

case "${command}" in
    compile)     cmd_compile "$@" ;;
    compile-all) cmd_compile_all "$@" ;;
    fmt)         cmd_fmt "$@" ;;
    watch)       cmd_watch "$@" ;;
    --help|-h|help|"") usage ;;
    *) echo "Unknown command: ${command}" >&2; usage; exit 1 ;;
esac
