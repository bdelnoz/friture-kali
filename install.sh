#!/usr/bin/env bash
# =============================================================================
# Script      : /mnt/data2_78g/Security/scripts/Projects_multimedia/friture-kali/install.sh
# Author      : Bruno DELNOZ
# Email       : bruno.delnoz@protonmail.com
# Version     : v1.3.0
# Date        : 2026-04-25
# Target      : Install Friture audio spectrum analyzer in a dedicated Python
#               venv for Kali Linux at a fixed project installation folder
# -----------------------------------------------------------------------------
# Changelog   :
#   v1.3.0 – 2026-04-25 – Python runtime compatibility hardening
#               - detect and use a Python interpreter < 3.13 for venv creation
#               - auto-try python3.12 installation in --install when unavailable
#               - block incompatible pip fallback on Python 3.13+
#   v1.2.0 – 2026-04-25 – Python 3.13 compatibility fix
#               - prefer apt package `friture` during --exec to avoid pip build
#                 failures with legacy numpy on Python 3.13
#               - keep pip fallback only when apt package is unavailable
#               - keep fixed installation root and fixed venv policy
#   v1.1.0 – 2026-04-25 – Fixed installation root and venv location for Kali
#               - fixed INSTALL_ROOT path to /mnt/data2_78g/.../friture-kali
#               - venv now created in INSTALL_ROOT/venv/friture
#               - safer log handling for purge and early logging calls
#               - help/defaults synchronized with fixed installation policy
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
SCRIPT_VERSION="v1.3.0"
SCRIPT_DATE="2026-04-25"
AUTHOR="Bruno DELNOZ"
EMAIL="bruno.delnoz@protonmail.com"

INSTALL_ROOT="/mnt/data2_78g/Security/scripts/Projects_multimedia/friture-kali"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
VENV_DIR="${INSTALL_ROOT}/venv/friture"
LOGS_DIR="${INSTALL_ROOT}/logs"
RESULTS_DIR="${INSTALL_ROOT}/results"
TIMESTAMP="$(date '+%Y%m%d_%H%M%S')"
LOG_FILE="${LOGS_DIR}/log.${SCRIPT_NAME}.${TIMESTAMP}.${SCRIPT_VERSION}.log"

SIMULATE=false
DO_EXEC=false
STEP=0
TOTAL_STEPS=7
SELECTED_PYTHON=""
SELECTED_PYTHON_VERSION=""

# System packages required
SYS_DEPS=("python3-venv" "python3-pyqt5" "python3-pyqt5.qtopengl" "python3-pip")

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
    mkdir -p "${INSTALL_ROOT}" "${LOGS_DIR}" "${RESULTS_DIR}"
    # Append /logs and /results to .gitignore if present
    local gitignore="${INSTALL_ROOT}/.gitignore"
    if [[ -f "${gitignore}" ]]; then
        grep -qxF '/logs' "${gitignore}" || echo -e "\n# Added automatically by ${SCRIPT_NAME}\n/logs" >> "${gitignore}"
        grep -qxF '/results' "${gitignore}" || echo "/results" >> "${gitignore}"
        grep -qxF '/venv' "${gitignore}" || echo "/venv" >> "${gitignore}"
    fi
}

# Log message to file and stdout
log() {
    mkdir -p "${LOGS_DIR}"
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

# Verify fixed project installation folder
check_install_root() {
    if [[ "${SCRIPT_DIR}" != "${INSTALL_ROOT}" ]]; then
        log "[WARN] Script current location: ${SCRIPT_DIR}"
        log "[WARN] Required installation root: ${INSTALL_ROOT}"
        log "[WARN] The script will still use fixed paths under ${INSTALL_ROOT}."
    else
        log "[OK] Script is running from fixed installation root: ${INSTALL_ROOT}"
    fi
}

# =============================================================================
# HELP
# =============================================================================
show_help() {
    cat <<EOF_HELP
================================================================================
  ${SCRIPT_NAME} – ${SCRIPT_VERSION} – ${AUTHOR} <${EMAIL}>
================================================================================

DESCRIPTION
  Installs Friture audio spectrum analyzer inside a dedicated Python venv
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
  --purge,     -pu   Remove ./logs and ./results directories in INSTALL_ROOT
  --stop,      -st   (N/A for install script)

EXAMPLES
  # Check prerequisites only
  ./${SCRIPT_NAME} --prerequis

  # Install missing system deps
  ./${SCRIPT_NAME} --install

  # Full installation (recommended)
  ./${SCRIPT_NAME} --exec

  # Simulate installation (dry-run)
  ./${SCRIPT_NAME} --exec --simulate

  # Check prerequisites then install
  ./${SCRIPT_NAME} --prerequis && ./${SCRIPT_NAME} --install && ./${SCRIPT_NAME} --exec

DEFAULTS
  INSTALL_ROOT : ${INSTALL_ROOT}
  VENV_DIR     : ${VENV_DIR}
  LOGS_DIR     : ${LOGS_DIR}
  RESULTS_DIR  : ${RESULTS_DIR}

NOTES
  - Requires Kali Linux with apt
  - Uses --system-site-packages to reuse python3-pyqt5 from system
  - No external sudo required (sudo is handled internally)
================================================================================
EOF_HELP
}

# =============================================================================
# CHANGELOG
# =============================================================================
show_changelog() {
    cat <<EOF_CHANGELOG
================================================================================
  CHANGELOG – ${SCRIPT_NAME}
================================================================================

  v1.3.0 – 2026-04-25 – ${AUTHOR}
    - Added compatible interpreter detection (< 3.13) for venv creation
    - Added optional python3.12 installation attempt during --install
    - Blocked pip fallback when only Python 3.13+ is available

  v1.2.0 – 2026-04-25 – ${AUTHOR}
    - Prefer apt package `friture` for Python 3.13 compatibility
    - Keep pip fallback only if apt package is unavailable
    - Preserve fixed INSTALL_ROOT and fixed VENV_DIR policy

  v1.1.0 – 2026-04-25 – ${AUTHOR}
    - Fixed installation root to ${INSTALL_ROOT}
    - Venv moved to ${VENV_DIR}
    - Added install root validation and informative warnings
    - Improved log safety for purge and early execution paths

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
EOF_CHANGELOG
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

    # Check compatible interpreter for venv (< 3.13)
    if detect_compatible_python; then
        log "  [OK]      compatible venv interpreter: ${SELECTED_PYTHON} (${SELECTED_PYTHON_VERSION})"
    else
        log "  [MISSING] compatible venv interpreter (< 3.13)"
        log "            Recommended: python3.12 + python3.12-venv"
        missing+=("python3.12")
        missing+=("python3.12-venv")
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

# Return success only if interpreter version is < 3.13
is_compatible_python() {
    local py="$1"
    "${py}" -c 'import sys; raise SystemExit(0 if sys.version_info < (3, 13) else 1)'
}

# Detect best available interpreter (<3.13) for venv creation
detect_compatible_python() {
    local candidates=("python3.12" "python3.11" "python3.10" "python3.9")
    local py
    for py in "${candidates[@]}"; do
        if command -v "${py}" &>/dev/null; then
            if is_compatible_python "${py}"; then
                SELECTED_PYTHON="${py}"
                SELECTED_PYTHON_VERSION="$(${py} --version 2>&1)"
                return 0
            fi
        fi
    done

    if command -v python3 &>/dev/null && is_compatible_python python3; then
        SELECTED_PYTHON="python3"
        SELECTED_PYTHON_VERSION="$(python3 --version 2>&1)"
        return 0
    fi

    SELECTED_PYTHON=""
    SELECTED_PYTHON_VERSION=""
    return 1
}

# =============================================================================
# INSTALL SYSTEM PREREQUISITES
# =============================================================================
install_prereqs() {
    step "Installing system prerequisites via apt"
    run_cmd "apt update" apt-get update -qq
    run_cmd "apt install system deps" apt-get install -y "${SYS_DEPS[@]}"
    if ! detect_compatible_python; then
        if apt-cache show python3.12 &>/dev/null && apt-cache show python3.12-venv &>/dev/null; then
            run_cmd "apt install python3.12 and python3.12-venv" apt-get install -y python3.12 python3.12-venv
        fi
    fi
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

    step "Checking fixed installation root"
    check_install_root

    # Step 1 – Check prereqs
    step "Checking system prerequisites"
    if ! check_prereqs; then
        log "[WARN] Missing prerequisites detected. Run --install first or continue at your own risk."
    fi

    # Step 2 – Create venv
    step "Creating Python venv at ${VENV_DIR}"
    if ! detect_compatible_python; then
        log "[ERROR] No compatible Python interpreter (< 3.13) found."
        log "[ERROR] Python 3.13+ cannot build current pip fallback dependencies for friture."
        log "[ERROR] Run: ./${SCRIPT_NAME} --install  (will try installing python3.12 if available)."
        exit 1
    fi
    log "  Using interpreter for venv: ${SELECTED_PYTHON} (${SELECTED_PYTHON_VERSION})"
    if [[ -d "${VENV_DIR}" ]]; then
        if [[ -x "${VENV_DIR}/bin/python" ]] && "${VENV_DIR}/bin/python" -c 'import sys; raise SystemExit(0 if sys.version_info < (3, 13) else 1)'; then
            log "  existing venv is compatible – skipping recreation"
        else
            log "  [WARN] existing venv is incompatible (Python 3.13+ or broken). Recreating with ${SELECTED_PYTHON}."
            if [[ "${SIMULATE}" == true ]]; then
                log "[SIMULATE] Would remove venv: ${VENV_DIR}"
                run_cmd "${SELECTED_PYTHON} -m venv" "${SELECTED_PYTHON}" -m venv "${VENV_DIR}" --system-site-packages
            else
                rm -rf "${VENV_DIR}"
                mkdir -p "$(dirname "${VENV_DIR}")"
                run_cmd "${SELECTED_PYTHON} -m venv" "${SELECTED_PYTHON}" -m venv "${VENV_DIR}" --system-site-packages
            fi
            log "  venv recreated at ${VENV_DIR}"
        fi
    else
        mkdir -p "$(dirname "${VENV_DIR}")"
        run_cmd "${SELECTED_PYTHON} -m venv" "${SELECTED_PYTHON}" -m venv "${VENV_DIR}" --system-site-packages
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
    run_cmd "pip upgrade" "${VENV_DIR}/bin/python" -m pip install --upgrade pip

    # Step 5 – Install friture (apt preferred, pip fallback)
    step "Installing friture (apt preferred, pip fallback)"
    if command -v friture &>/dev/null; then
        log "  friture command already available in PATH – skipping installation"
    else
        if apt-cache show friture &>/dev/null; then
            if [[ $EUID -ne 0 ]]; then
                run_cmd "apt install friture (sudo)" sudo -E apt-get install -y friture
            else
                run_cmd "apt install friture" apt-get install -y friture
            fi
        else
            log "  [WARN] apt package 'friture' not found. Falling back to pip."
            if [[ "${SIMULATE}" == true ]]; then
                run_cmd "pip install friture" "${VENV_DIR}/bin/python" -m pip install friture
            elif [[ -x "${VENV_DIR}/bin/python" ]] && "${VENV_DIR}/bin/python" -c 'import sys; raise SystemExit(0 if sys.version_info < (3, 13) else 1)'; then
                run_cmd "pip install friture" "${VENV_DIR}/bin/python" -m pip install friture
            else
                log "[ERROR] Pip fallback blocked: venv Python is 3.13+ and known to fail with current friture backend dependencies."
                log "[ERROR] Install python3.12 + python3.12-venv, then rerun --exec to recreate a compatible venv."
                exit 1
            fi
        fi
    fi

    # Step 6 – Write results summary
    step "Writing installation summary"
    local result_file="${RESULTS_DIR}/install.${TIMESTAMP}.txt"
    if [[ "${SIMULATE}" == false ]]; then
        {
            echo "friture-kali installation summary"
            echo "Date        : $(date '+%Y-%m-%d %H:%M:%S')"
            echo "Script      : ${SCRIPT_NAME} ${SCRIPT_VERSION}"
            echo "INSTALL_ROOT: ${INSTALL_ROOT}"
            echo "VENV_DIR    : ${VENV_DIR}"
            echo "Friture cmd : $(command -v friture 2>/dev/null || echo 'not found')"
        } > "${result_file}"
        log "  Result written to ${result_file}"
    fi

    log "========================================"
    log "  INSTALLATION COMPLETE"
    log "  To launch: source ${VENV_DIR}/bin/activate && friture"
    log "  Or use   : ${INSTALL_ROOT}/run.sh --exec"
    log "========================================"

    # Post-execution summary
    echo ""
    echo "Actions performed:"
    echo "  1. Installation root check"
    echo "  2. Prerequisite check"
    echo "  3. venv creation at ${VENV_DIR}"
    echo "  4. venv activation"
    echo "  5. pip upgrade"
    echo "  6. friture installation checked/performed (apt preferred)"
    echo "  7. Result summary written"
}

# =============================================================================
# PURGE
# =============================================================================
do_purge() {
    init_dirs
    log "Purging logs and results in fixed installation root..."
    rm -rf "${LOGS_DIR}" "${RESULTS_DIR}"
    mkdir -p "${LOGS_DIR}"
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
            check_install_root
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
            DO_EXEC=true
            ;;
        --stop|-st)
            init_dirs
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
if [[ "${DO_EXEC}" == true ]]; then
    init_dirs
    do_exec
fi
