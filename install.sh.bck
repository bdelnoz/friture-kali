#!/usr/bin/env bash
# =============================================================================
# Script      : /mnt/data2_78g/Security/scripts/Projects_multimedia/friture-kali/install.sh
# Author      : Bruno DELNOZ
# Email       : bruno.delnoz@protonmail.com
# Version     : v1.6.0
# Date        : 2026-04-26
# Target      : Install Friture audio spectrum analyzer using pipenv
#               for Kali Linux at a fixed project installation folder
# -----------------------------------------------------------------------------
# Changelog   :
#   v1.6.0 – 2026-04-26 – Migrate to pipenv
#               - use pipenv install friture instead of manual venv
#               - simplify prerequisite checks (pipenv only)
#               - remove manual venv management
#               - create Pipfile automatically
# =============================================================================

set -euo pipefail

SCRIPT_NAME="install.sh"
SCRIPT_VERSION="v1.6.0"
SCRIPT_DATE="2026-04-26"
AUTHOR="Bruno DELNOZ"
EMAIL="bruno.delnoz@protonmail.com"

INSTALL_ROOT="/mnt/data2_78g/Security/scripts/Projects_multimedia/friture-kali"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
LOGS_DIR="${INSTALL_ROOT}/logs"
RESULTS_DIR="${INSTALL_ROOT}/results"
TIMESTAMP="$(date '+%Y%m%d_%H%M%S')"
LOG_FILE="${LOGS_DIR}/log.${SCRIPT_NAME}.${TIMESTAMP}.${SCRIPT_VERSION}.log"

SIMULATE=false
DO_EXEC=false
STEP=0
TOTAL_STEPS=5

SYS_DEPS=("pipenv" "python3-pyqt5" "python3-pyqt5.qtopengl" "git")

# Save original args for ensure_sudo
ORIGINAL_ARGS=("$@")

ensure_sudo() {
    if [[ $EUID -ne 0 ]]; then
        exec sudo -E bash "$0" "$@"
    fi
}

init_dirs() {
    mkdir -p "${INSTALL_ROOT}" "${LOGS_DIR}" "${RESULTS_DIR}"
    local gitignore="${INSTALL_ROOT}/.gitignore"
    if [[ -f "${gitignore}" ]]; then
        grep -qxF '/.venv' "${gitignore}" || echo -e "\n# Added automatically by ${SCRIPT_NAME}\n/.venv" >> "${gitignore}"
        grep -qxF '/Pipfile.lock' "${gitignore}" || echo "/Pipfile.lock" >> "${gitignore}"
        grep -qxF '/logs' "${gitignore}" || echo "/logs" >> "${gitignore}"
        grep -qxF '/results' "${gitignore}" || echo "/results" >> "${gitignore}"
    fi
}

log() {
    mkdir -p "${LOGS_DIR}"
    local msg="[$(date '+%Y-%m-%d %H:%M:%S')] $*"
    echo "${msg}"
    echo "${msg}" >> "${LOG_FILE}"
}

step() {
    STEP=$((STEP + 1))
    log "──── Step ${STEP}/${TOTAL_STEPS}: $*"
}

run_cmd() {
    local desc="$1"; shift
    if [[ "${SIMULATE}" == true ]]; then
        log "[SIMULATE] Would run: $*  (${desc})"
    else
        log "[EXEC] ${desc}"
        "$@" 2>&1 | tee -a "${LOG_FILE}"
    fi
}

check_install_root() {
    if [[ "${SCRIPT_DIR}" != "${INSTALL_ROOT}" ]]; then
        log "[WARN] Script current location: ${SCRIPT_DIR}"
        log "[WARN] Required installation root: ${INSTALL_ROOT}"
        log "[WARN] The script will still use fixed paths under ${INSTALL_ROOT}."
    else
        log "[OK] Script is running from fixed installation root: ${INSTALL_ROOT}"
    fi
}

show_help() {
    cat <<EOF_HELP
================================================================================
  ${SCRIPT_NAME} – ${SCRIPT_VERSION} – ${AUTHOR} <${EMAIL}>
================================================================================

DESCRIPTION
  Installs Friture audio spectrum analyzer using pipenv
  on Kali Linux. Manages dependencies and Python environment.

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
  ./${SCRIPT_NAME} --prerequis
  ./${SCRIPT_NAME} --install
  ./${SCRIPT_NAME} --exec
  ./${SCRIPT_NAME} --exec --simulate

DEFAULTS
  INSTALL_ROOT : ${INSTALL_ROOT}
  LOGS_DIR     : ${LOGS_DIR}
  RESULTS_DIR  : ${RESULTS_DIR}

NOTES
  - Requires Kali Linux with apt
  - Uses pipenv for Python environment and dependency management
  - No external sudo required (sudo is handled internally)
================================================================================
EOF_HELP
}

show_changelog() {
    cat <<EOF_CHANGELOG
================================================================================
  CHANGELOG – ${SCRIPT_NAME}
================================================================================

  v1.6.0 – 2026-04-26 – ${AUTHOR}
    - Migrate to pipenv for dependency management
    - Use pipenv install friture instead of manual venv
    - Simplify prerequisite checks (pipenv only)
    - Remove manual venv activation and management
    - Auto-generate Pipfile

  v1.5.0 – 2026-04-26
    - Validate venv creation (check bin/python exists)
    - Use --upgrade-deps during venv creation
    - Force venv deletion if creation fails
    - Strict error checking on activate step
    - Skip git fallback (incompatible with Python 3.13)

  v1.4.0 – 2026-04-25
    - Added fallback path when only Python 3.13 is available
    - Added git-based install attempt from upstream Friture repository
    - Removed hard-stop dead-end before installation attempts

================================================================================
EOF_CHANGELOG
}

check_prereqs() {
    log "Checking system prerequisites..."
    local missing=()

    if command -v pipenv &>/dev/null; then
        log "  [OK]      pipenv"
    else
        log "  [MISSING] pipenv"
        missing+=("pipenv")
    fi

    if dpkg -l | grep -q '^ii.*python3-pyqt5'; then
        log "  [OK]      python3-pyqt5"
    else
        log "  [MISSING] python3-pyqt5"
        missing+=("python3-pyqt5")
    fi

    if python3 -c "from PyQt5 import QtOpenGL" 2>/dev/null; then
        log "  [OK]      python3-pyqt5.qtopengl"
    else
        log "  [MISSING] python3-pyqt5.qtopengl"
        missing+=("python3-pyqt5.qtopengl")
    fi

    if command -v git &>/dev/null; then
        log "  [OK]      git"
    else
        log "  [MISSING] git"
        missing+=("git")
    fi

    if command -v python3 &>/dev/null; then
        local py_version
        py_version="$(python3 --version 2>&1)"
        log "  [OK]      python3 (${py_version})"
    else
        log "  [MISSING] python3"
        missing+=("python3")
    fi

    if [[ ${#missing[@]} -eq 0 ]]; then
        log "All prerequisites satisfied."
    else
        log "Missing prerequisites: ${missing[*]}"
        log "Run: ./${SCRIPT_NAME} --install  to install them."
        return 1
    fi
}

install_prereqs() {
    step "Installing system prerequisites via apt"
    run_cmd "apt update" apt-get update -qq
    run_cmd "apt install system deps" apt-get install -y "${SYS_DEPS[@]}"
    log "System prerequisites installed."
}

do_exec() {
    init_dirs
    log "========================================"
    log "  ${SCRIPT_NAME} ${SCRIPT_VERSION} – START"
    log "========================================"

    step "Checking fixed installation root"
    check_install_root

    step "Checking system prerequisites"
    if ! check_prereqs; then
        log "[WARN] Missing prerequisites detected. Run --install first or continue at your own risk."
    fi

    step "Creating Pipfile and venv (if missing)"
    if [[ "${SIMULATE}" == false ]]; then
        cd "${INSTALL_ROOT}"
        # Fix ownership if venv created by root
        if [[ -d .venv ]]; then
            sudo chown -R "${SUDO_USER:-nox}:${SUDO_USER:-nox}" .venv 2>/dev/null || true
            log "  .venv exists – skipping recreation"
        else
            log "  Generating Pipfile and venv..."
            run_cmd "pipenv --python 3.13" env PIPENV_VENV_IN_PROJECT=1 PIPENV_IGNORE_VIRTUALENVS=1 pipenv --python 3.13
            sudo chown -R "${SUDO_USER:-nox}:${SUDO_USER:-nox}" .venv 2>/dev/null || true
            log "  Pipfile and venv created"
        fi
    fi

    step "Installing friture"
    if [[ "${SIMULATE}" == false ]]; then
        cd "${INSTALL_ROOT}"
        log "  Installing friture from upstream master (Python 3.13 compatible)..."
        if run_cmd "pip install friture@master" \
            env PIPENV_VENV_IN_PROJECT=1 PIPENV_IGNORE_VIRTUALENVS=1 \
            pipenv run pip install "git+https://github.com/tlecomte/friture.git@master" 2>&1 | tee -a "${LOG_FILE}"; then
            log "  friture 0.54+ installed from upstream master"
        else
            log "  [ERROR] pip install friture@master failed."
            exit 1
        fi
    else
        log "[SIMULATE] Would run: pipenv run pip install git+https://github.com/tlecomte/friture.git@master"
    fi

    step "Writing installation summary"
    local result_file="${RESULTS_DIR}/install.${TIMESTAMP}.txt"
    if [[ "${SIMULATE}" == false ]]; then
        cd "${INSTALL_ROOT}"
        {
            echo "friture-kali installation summary (pipenv)"
            echo "Date        : $(date '+%Y-%m-%d %H:%M:%S')"
            echo "Script      : ${SCRIPT_NAME} ${SCRIPT_VERSION}"
            echo "INSTALL_ROOT: ${INSTALL_ROOT}"
            echo "Launch cmd  : pipenv run friture"
        } > "${result_file}"
        log "  Result written to ${result_file}"
    fi

    log "========================================"
    log "  INSTALLATION COMPLETE"
    log "  To launch: cd ${INSTALL_ROOT} && pipenv run friture"
    log "  Or use   : ${INSTALL_ROOT}/run.sh --exec"
    log "========================================"

    echo ""
    echo "Actions performed:"
    echo "  1. Installation root check"
    echo "  2. Prerequisite check"
    echo "  3. Pipfile creation (if needed)"
    echo "  4. friture installation (apt preferred, pipenv fallback)"
    echo "  5. Result summary written"
}

do_purge() {
    init_dirs
    log "Purging logs and results in fixed installation root..."
    rm -rf "${LOGS_DIR}" "${RESULTS_DIR}"
    mkdir -p "${LOGS_DIR}"
    log "Done."
}

if [[ $# -eq 0 ]]; then
    show_help
    exit 0
fi

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
            ensure_sudo "${ORIGINAL_ARGS[@]}"
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

if [[ "${DO_EXEC}" == true ]]; then
    init_dirs
    ensure_sudo "${ORIGINAL_ARGS[@]}"
    do_exec
fi
