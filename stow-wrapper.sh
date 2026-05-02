#!/bin/bash
set -euo pipefail

SCRIPT_PATH="${BASH_SOURCE[0]}"
SCRIPT_DIR="$(cd "${SCRIPT_PATH%/*}" && pwd)"
DRY_RUN=false
MACHINE_TYPE=""
VERBOSE=false
STOW_BIN="${STOW_BIN:-/usr/bin/stow}"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_info() { echo -e "${BLUE}ℹ${NC} $*"; }
print_success() { echo -e "${GREEN}✓${NC} $*"; }
print_warning() { echo -e "${YELLOW}⚠${NC} $*"; }
print_error() { echo -e "${RED}✗${NC} $*" >&2; }

show_help() {
  cat << 'EOF'
stow-wrapper.sh - GNU stow automation for laptop/desktop dotfiles
USAGE: ./stow-wrapper.sh [laptop|desktop|--help|--dry-run|--verbose]
EXAMPLES:
  ./stow-wrapper.sh         # Auto-detect machine
  ./stow-wrapper.sh laptop  # Force laptop setup
EOF
}

detect_machine_type() {
  local hostname=$(hostname -s | tr '[:upper:]' '[:lower:]')
  if [[ "$hostname" == *laptop* ]]; then
    echo "laptop"
  elif [[ "$hostname" == *desktop* ]]; then
    echo "desktop"
  else
    echo "laptop"
  fi
}

run_stow() {
  local pkg="$1"
  local stow_dir="$2"
  local args=("--no-folding")
  
  [[ "$DRY_RUN" == true ]] && args+=("--no")
  [[ "$VERBOSE" == true ]] && args+=("--verbose=2")
  
  args+=("--dir=$stow_dir" "--target=$HOME" "$pkg")
  
  [[ "$VERBOSE" == true ]] && print_info "stow ${args[*]}"
  
  "$STOW_BIN" "${args[@]}" || { print_error "Failed: $pkg from $stow_dir"; return 1; }
}

apply_config() {
  print_info "Applying: ${BLUE}$MACHINE_TYPE${NC}"
  echo ""
  
  local failed=false
  
  # Stow shared packages
  for pkg in code nvim tmux zsh; do
    [[ -d "$SCRIPT_DIR/shared/$pkg" ]] || continue
    print_info "Stowing: shared/$pkg"
    run_stow "$pkg" "$SCRIPT_DIR/shared" || failed=true
  done
  
  echo ""
  
  # Stow machine-specific packages
  if [[ "$MACHINE_TYPE" == "laptop" ]]; then
    for pkg in i3 sway hyprland x; do
      [[ -d "$SCRIPT_DIR/laptop/$pkg" ]] || continue
      print_info "Stowing: laptop/$pkg"
      run_stow "$pkg" "$SCRIPT_DIR/laptop" || failed=true
    done
  else
    for pkg in i3 hyprland x; do
      [[ -d "$SCRIPT_DIR/desktop/$pkg" ]] || continue
      print_info "Stowing: desktop/$pkg"
      run_stow "$pkg" "$SCRIPT_DIR/desktop" || failed=true
    done
  fi
  
  echo ""
  
  # Stow terminal emulator
  STOW_TERMINAL="${STOW_TERMINAL:-kitty}"
  [[ -d "$SCRIPT_DIR/terminal-emulators/$STOW_TERMINAL" ]] || { print_error "Terminal not found: $STOW_TERMINAL"; return 1; }
  print_info "Stowing: terminal-emulators/$STOW_TERMINAL"
  run_stow "$STOW_TERMINAL" "$SCRIPT_DIR/terminal-emulators" || failed=true
  
  echo ""
  if [[ "$failed" == true ]]; then
    print_warning "Some packages failed"
    return 1
  fi
  
  print_success "Configuration applied!"
  return 0
}

# Parse arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    --help|-h) show_help; exit 0 ;;
    --dry-run) DRY_RUN=true; print_info "Dry-run mode"; shift ;;
    --verbose|-v) VERBOSE=true; shift ;;
    laptop|desktop) MACHINE_TYPE="$1"; shift ;;
    *) print_error "Unknown: $1"; show_help; exit 1 ;;
  esac
done

# Set machine type
[[ -z "$MACHINE_TYPE" ]] && MACHINE_TYPE="${STOW_MACHINE:-$(detect_machine_type)}"
[[ -z "$MACHINE_TYPE" ]] && { print_error "No machine type"; exit 1; }

if [[ ! -x "$STOW_BIN" && -x /bin/stow ]]; then
  STOW_BIN=/bin/stow
fi

if [[ ! -x "$STOW_BIN" ]]; then
  print_error "stow binary not found (tried: $STOW_BIN, /bin/stow)"
  exit 1
fi

print_info "Machine: ${BLUE}$MACHINE_TYPE${NC}"
apply_config
exit $?
