#!/usr/bin/env bash
# =============================================================================
# Script      : /home/nox/Projects/friture-kali/install.sh
# Author      : Bruno DELNOZ
# Email       : bruno.delnoz@protonmail.com
# Version     : v1.0.0
# Date        : 2026-04-25
# Target      : Install Friture audio spectrum analyzer in isolated Python venv
#               on Kali Linux with Blue Yeti USB microphone support
# -----------------------------------------------------------------------------
# Changelog   :
#   v1.0.0 – 2026-04-25 – Initial version
#               - venv creation with --system-site-packages
#               - pip install friture
#               - prerequisite checks (python3-pyqt5, python3-venv)
#               - apt install of missing system deps
#               - All SOLO200 args: --help --exec --prerequis --install
#                 --simulate --changelog --purge --stop
# =============================================================================

set -euo pipefail

# =============================================================================
# CONSTANTS
# =============================================================================
SCRIPT_NAME="install.sh"
SCRIPT_VERSION="v1.0.0"
SCRIPT_DATE="2026-04-25"
AUTHOR="Bruno DELNOZ"
EMAIL="bruno.delnoz@protonmail.com"

VENV_DIR="${HOME}/venv/friture"
LOGS_DIR="$(cd "$(dirname "$0")" && pwd)/logs"
RESULTS_DIR="$(cd "$(dirname "$0")" && pwd)/results"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TIMESTAMP="$(date '+%Y%m%d_%H%M%S')"
LOG_FILE="${LOGS_DIR}/log.${SCRIPT_NAME}.${TIMESTAMP}.${SCRIPT_VERSION}.log"

SIMULATE=false
STEP=0
TOTAL_STEPS=6

# System packages required
SYS_DEPS=("python3-venv" "python3-pyqt5" "python3-pyqt5.qtopengl")

# =============================================================================
# INTERNAL FUNCTIONS
# =============================================================================

# Ensure script runs with root privileges internally
ensure_sudo() {
    if [[ $EUID -ne 0 ]]; then
        exec sudo -E bash "$0" "$@"
    fi
}

# Initialize log and result directories
init_dirs() {
    mkdir -p "${LOGS_DIR}" "${RESULTS_DIR}"
    # Append /logs and /results to .gitignore if present
    local gitignore="${SCRIPT_DIR}/.gitignore"
    if [[ -f "${gitignore}" ]]; then
        grep -qxF '/logs' "${gitignore}" || echo -e "\n# Added automatically by ${SCRIPT_NAME}\n/logs" >> "${gitignore}"
        grep -qxF '/results' "${gitignore}" || echo "/results" >> "${gitignore}"
    fi
}

# Log message to file and stdout
log() {
    local msg="[$(date '+%Y-%m-%d %H:%M:%S')] $*"
    echo "${msg}"
    echo "${msg}" >> "${LOG_FILE}"
}

# Show step progress
step() {
    STEP=$((STEP + 1))
    log "──── Step ${STEP}/${TOTAL_STEPS}: $*"
}

# Simulate-aware action executor
run_cmd() {
    # $1 = description, rest = command
    local desc="$1"; shift
    if [[ "${SIMULATE}" == true ]]; then
        log "[SIMULATE] Would run: $*  (${desc})"
    else
        log "[EXEC] ${desc}"
        "$@" 2>&1 | tee -a "${LOG_FILE}"
    fi
}

# =============================================================================
# HELP
# =============================================================================
show_help() {
    cat <<EOF
================================================================================
  ${SCRIPT_NAME} – ${SCRIPT_VERSION} – ${AUTHOR} <${EMAIL}>
================================================================================

DESCRIPTION
  Installs Friture audio spectrum analyzer inside an isolated Python venv
  on Kali Linux. Handles system dependencies and venv creation.

USAGE
  ./${SCRIPT_NAME} [OPTION]

OPTIONS
  --help,      -h    Show this help and exit
  --exec,      -exe  Run the full installation
  --prerequis, -pr   Check system prerequisites (no install)
  --install,   -i    Install missing system prerequisites via apt
  --simulate,  -s    Dry-run mode (no actual changes made)
  --changelog, -ch   Show full changelog
  --purge,     -pu   Remove ./logs and ./results directories
  --stop,      -st   (N/A for install script)

EXAMPLES
  # Check prerequisites only
  ./${SCRIPT_NAME} --prerequis

  # Install missing system deps
  sudo ./${SCRIPT_NAME} --install

  # Full installation (recommended)
  ./${SCRIPT_NAME} --exec

  # Simulate installation (dry-run)
  ./${SCRIPT_NAME} --exec --simulate

  # Check prerequisites then install
  ./${SCRIPT_NAME} --prerequis && ./${SCRIPT_NAME} --install && ./${SCRIPT_NAME} --exec

DEFAULTS
  VENV_DIR    : ${HOME}/venv/friture
  LOGS_DIR    : ./logs
  RESULTS_DIR : ./results

NOTES
  - Requires Kali Linux with apt
  - Uses --system-site-packages to reuse python3-pyqt5 from system
  - No external sudo required (sudo is handled internally)
================================================================================
EOF
}

# =============================================================================
# CHANGELOG
# =============================================================================
show_changelog() {
    cat <<EOF
================================================================================
  CHANGELOG – ${SCRIPT_NAME}
================================================================================

  v1.0.0 – 2026-04-25 – ${AUTHOR}
    - Initial version
    - venv creation at ~/venv/friture with --system-site-packages
    - pip install friture inside venv
    - System dependency checks: python3-venv, python3-pyqt5, python3-pyqt5.qtopengl
    - apt install of missing system packages
    - .gitignore management (auto-add /logs, /results)
    - Full SOLO200 argument set
    - Step-by-step progress display
    - Dry-run / simulate mode

================================================================================
EOF
}

# =============================================================================
# PREREQUISITE CHECK
# =============================================================================
check_prereqs() {
    log "Checking system prerequisites..."
    local missing=()
    for pkg in "${SYS_DEPS[@]}"; do
        if dpkg -s "${pkg}" &>/dev/null; then
            log "  [OK]      ${pkg}"
        else
            log "  [MISSING] ${pkg}"
            missing+=("${pkg}")
        fi
    done

    # Check python3
    if command -v python3 &>/dev/null; then
        log "  [OK]      python3 ($(python3 --version 2>&1))"
    else
        log "  [MISSING] python3"
        missing+=("python3")
    fi

    # Check pip
    if command -v pip3 &>/dev/null || python3 -m pip --version &>/dev/null 2>&1; then
        log "  [OK]      pip3"
    else
        log "  [MISSING] pip3"
        missing+=("python3-pip")
    fi

    # Report
    if [[ ${#missing[@]} -eq 0 ]]; then
        log "All prerequisites satisfied."
    else
        log "Missing prerequisites: ${missing[*]}"
        log "Run: ./${SCRIPT_NAME} --install  to install them."
        return 1
    fi
}

# =============================================================================
# INSTALL SYSTEM PREREQUISITES
# =============================================================================
install_prereqs() {
    step "Installing system prerequisites via apt"
    run_cmd "apt update" apt-get update -qq
    run_cmd "apt install system deps" apt-get install -y "${SYS_DEPS[@]}"
    log "System prerequisites installed."
}

# =============================================================================
# MAIN INSTALLATION
# =============================================================================
do_exec() {
    init_dirs
    log "========================================"
    log "  ${SCRIPT_NAME} ${SCRIPT_VERSION} – START"
    log "========================================"

    # Step 1 – Check prereqs
    step "Checking system prerequisites"
    if ! check_prereqs; then
        log "[WARN] Missing prerequisites detected. Run --install first or continue at your own risk."
    fi

    # Step 2 – Create venv
    step "Creating Python venv at ${VENV_DIR}"
    if [[ -d "${VENV_DIR}" ]]; then
        log "  venv already exists at ${VENV_DIR} – skipping creation"
    else
        run_cmd "python3 -m venv" python3 -m venv "${VENV_DIR}" --system-site-packages
        log "  venv created at ${VENV_DIR}"
    fi

    # Step 3 – Activate venv
    step "Activating venv"
    if [[ "${SIMULATE}" == true ]]; then
        log "[SIMULATE] Would activate: source ${VENV_DIR}/bin/activate"
    else
        # shellcheck disable=SC1090
        source "${VENV_DIR}/bin/activate"
        log "  venv activated"
    fi

    # Step 4 – Upgrade pip inside venv
    step "Upgrading pip inside venv"
    run_cmd "pip upgrade" pip install --upgrade pip

    # Step 5 – Install friture
    step "Installing friture via pip"
    run_cmd "pip install friture" pip install friture

    # Step 6 – Write results summary
    step "Writing installation summary"
    local result_file="${RESULTS_DIR}/install.${TIMESTAMP}.txt"
    if [[ "${SIMULATE}" == false ]]; then
        {
            echo "friture-kali installation summary"
            echo "Date        : $(date '+%Y-%m-%d %H:%M:%S')"
            echo "Script      : ${SCRIPT_NAME} ${SCRIPT_VERSION}"
            echo "VENV_DIR    : ${VENV_DIR}"
            echo "Friture ver : $(pip show friture 2>/dev/null | grep Version || echo 'unknown')"
        } > "${result_file}"
        log "  Result written to ${result_file}"
    fi

    log "========================================"
    log "  INSTALLATION COMPLETE"
    log "  To launch: source ${VENV_DIR}/bin/activate && friture"
    log "  Or use   : ./run.sh --exec"
    log "========================================"

    # Post-execution summary
    echo ""
    echo "Actions performed:"
    echo "  1. Prerequisite check"
    echo "  2. venv creation at ${VENV_DIR}"
    echo "  3. venv activation"
    echo "  4. pip upgrade"
    echo "  5. friture installed via pip"
    echo "  6. Result summary written"
}

# =============================================================================
# PURGE
# =============================================================================
do_purge() {
    log "Purging ./logs and ./results..."
    rm -rf "${LOGS_DIR}" "${RESULTS_DIR}"
    log "Done."
}

# =============================================================================
# ARGUMENT PARSING
# =============================================================================
# Show help if no argument given
if [[ $# -eq 0 ]]; then
    show_help
    exit 0
fi

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --help|-h)
            show_help
            exit 0
            ;;
        --changelog|-ch)
            show_changelog
            exit 0
            ;;
        --prerequis|-pr)
            init_dirs
            check_prereqs
            exit $?
            ;;
        --install|-i)
            ensure_sudo "$@"
            init_dirs
            install_prereqs
            exit 0
            ;;
        --simulate|-s)
            SIMULATE=true
            ;;
        --exec|-exe)
            # Handled below after full arg parse
            DO_EXEC=true
            ;;
        --stop|-st)
            log "--stop not applicable for install script."
            exit 0
            ;;
        --purge|-pu)
            do_purge
            exit 0
            ;;
        *)
            echo "Unknown argument: $1"
            echo "Run ./${SCRIPT_NAME} --help for usage."
            exit 1
            ;;
    esac
    shift
done

# Execute if requested
if [[ "${DO_EXEC:-false}" == true ]]; then
    init_dirs
    do_exec
fi
