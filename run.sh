#!/usr/bin/env bash
# =============================================================================
# Script      : /mnt/data2_78g/Security/scripts/Projects_multimedia/friture-kali/run.sh
# Author      : Bruno DELNOZ
# Email       : bruno.delnoz@protonmail.com
# Version     : v1.2.0
# Date        : 2026-04-25
# Target      : Launch Friture from fixed Kali project installation root using
#               a dedicated Python venv and optional Blue Yeti checks
# -----------------------------------------------------------------------------
# Changelog   :
#   v1.2.0 – 2026-04-25 – Runtime compatibility with apt-based install
#               - accept system `friture` command when venv binary is absent
#               - keep fixed installation root and fixed venv policy
#   v1.1.0 – 2026-04-25 – Fixed root path and venv policy
#               - fixed INSTALL_ROOT path to /mnt/data2_78g/.../friture-kali
#               - venv path aligned to INSTALL_ROOT/venv/friture
#               - safer purge/log initialization behavior
#               - install fallback now targets fixed install.sh path
#   v1.0.0 – 2026-04-25 – Initial version
#               - venv existence check before launch
#               - ALSA Blue Yeti detection check (plughw:2,0)
#               - Friture launch from venv
#               - All SOLO200 args: --help --exec --prerequis --install
#                 --simulate --changelog --purge --stop
# =============================================================================

set -euo pipefail

# =============================================================================
# CONSTANTS
# =============================================================================
SCRIPT_NAME="run.sh"
SCRIPT_VERSION="v1.2.0"
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
FRITURE_PID_FILE="/tmp/friture.pid"

STEP=0
TOTAL_STEPS=5

# Expected Blue Yeti ALSA device
YETI_ALSA="plughw:2,0"
YETI_NAME="Yeti Stereo Microphone"

# =============================================================================
# INTERNAL FUNCTIONS
# =============================================================================

# Initialize directories and .gitignore
init_dirs() {
    mkdir -p "${INSTALL_ROOT}" "${LOGS_DIR}" "${RESULTS_DIR}"
    local gitignore="${INSTALL_ROOT}/.gitignore"
    if [[ -f "${gitignore}" ]]; then
        grep -qxF '/logs' "${gitignore}" || echo -e "\n# Added automatically by ${SCRIPT_NAME}\n/logs" >> "${gitignore}"
        grep -qxF '/results' "${gitignore}" || echo "/results" >> "${gitignore}"
        grep -qxF '/venv' "${gitignore}" || echo "/venv" >> "${gitignore}"
    fi
}

# Timestamped log
log() {
    mkdir -p "${LOGS_DIR}"
    local msg="[$(date '+%Y-%m-%d %H:%M:%S')] $*"
    echo "${msg}"
    echo "${msg}" >> "${LOG_FILE}"
}

# Step progress display
step() {
    STEP=$((STEP + 1))
    log "──── Step ${STEP}/${TOTAL_STEPS}: $*"
}

# Simulate-aware command runner
run_cmd() {
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
  Launches Friture audio spectrum analyzer from the fixed installation root
  and fixed Python venv path on Kali Linux.

USAGE
  ./${SCRIPT_NAME} [OPTION]

OPTIONS
  --help,      -h    Show this help and exit
  --exec,      -exe  Launch Friture (activate venv + start app)
  --stop,      -st   Kill running Friture instance
  --prerequis, -pr   Check venv and ALSA device availability
  --install,   -i    Re-run install.sh if venv missing
  --simulate,  -s    Dry-run mode (no actual launch)
  --changelog, -ch   Show full changelog
  --purge,     -pu   Remove logs and results from fixed installation root

EXAMPLES
  # Launch Friture
  ./${SCRIPT_NAME} --exec

  # Check venv + Blue Yeti before launching
  ./${SCRIPT_NAME} --prerequis && ./${SCRIPT_NAME} --exec

  # Dry-run (no actual launch)
  ./${SCRIPT_NAME} --exec --simulate

  # Stop Friture
  ./${SCRIPT_NAME} --stop

DEFAULTS
  INSTALL_ROOT : ${INSTALL_ROOT}
  VENV_DIR     : ${VENV_DIR}
  ALSA device  : ${YETI_ALSA} (${YETI_NAME})
  LOGS_DIR     : ${LOGS_DIR}
  RESULTS_DIR  : ${RESULTS_DIR}

NOTES
  - Friture must be installed first via: ${INSTALL_ROOT}/install.sh --exec
  - Select input device inside Friture: Preferences → Input device → Yeti
  - No external sudo required
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

  v1.2.0 – 2026-04-25 – ${AUTHOR}
    - Accept system `friture` command when venv binary is absent
    - Preserve fixed INSTALL_ROOT and fixed VENV_DIR policy

  v1.1.0 – 2026-04-25 – ${AUTHOR}
    - Fixed installation root to ${INSTALL_ROOT}
    - Venv path moved to ${VENV_DIR}
    - Added install root validation and warning logs
    - Improved purge/log safety behavior

  v1.0.0 – 2026-04-25 – ${AUTHOR}
    - Initial version
    - venv activation + Friture launch
    - ALSA Blue Yeti detection (plughw:2,0 / Yeti Stereo Microphone)
    - PID tracking in /tmp/friture.pid for --stop support
    - venv existence guard with install.sh fallback hint
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
    log "Checking runtime prerequisites..."
    local ok=true

    # Check install root policy
    check_install_root

    # Check venv
    if [[ -d "${VENV_DIR}" && -f "${VENV_DIR}/bin/activate" ]]; then
        log "  [OK]      venv found at ${VENV_DIR}"
    else
        log "  [MISSING] venv not found at ${VENV_DIR}"
        log "            Run: ${INSTALL_ROOT}/install.sh --exec  to create it"
        ok=false
    fi

    # Check friture command availability
    if [[ -f "${VENV_DIR}/bin/friture" ]]; then
        log "  [OK]      friture binary present in venv"
    elif command -v friture &>/dev/null; then
        log "  [OK]      friture command available in system PATH ($(command -v friture))"
    else
        log "  [MISSING] friture not found in venv and not available in system PATH"
        log "            Run: ${INSTALL_ROOT}/install.sh --exec"
        ok=false
    fi

    # Check Blue Yeti ALSA presence
    if arecord -l 2>/dev/null | grep -qi "Yeti"; then
        log "  [OK]      ${YETI_NAME} detected by ALSA"
    else
        log "  [WARN]    ${YETI_NAME} not detected by ALSA"
        log "            Device may be unplugged or on different card index"
        log "            Run: arecord -l  to check available devices"
    fi

    # Check DISPLAY env for GUI
    if [[ -n "${DISPLAY:-}" ]]; then
        log "  [OK]      DISPLAY set to ${DISPLAY}"
    else
        log "  [WARN]    DISPLAY not set – GUI may not launch"
    fi

    if [[ "${ok}" == true ]]; then
        log "All critical prerequisites satisfied."
        return 0
    else
        log "One or more critical prerequisites are missing."
        return 1
    fi
}

# =============================================================================
# INSTALL FALLBACK
# =============================================================================
do_install() {
    if [[ -f "${INSTALL_ROOT}/install.sh" ]]; then
        log "Delegating to fixed installer: ${INSTALL_ROOT}/install.sh --exec"
        bash "${INSTALL_ROOT}/install.sh" --exec
    else
        log "[ERROR] install.sh not found at ${INSTALL_ROOT}/install.sh"
        exit 1
    fi
}

# =============================================================================
# STOP FRITURE
# =============================================================================
do_stop() {
    log "Stopping Friture..."
    if [[ -f "${FRITURE_PID_FILE}" ]]; then
        local pid
        pid=$(cat "${FRITURE_PID_FILE}")
        if kill -0 "${pid}" 2>/dev/null; then
            kill "${pid}"
            log "  Friture (PID ${pid}) stopped."
            rm -f "${FRITURE_PID_FILE}"
        else
            log "  PID ${pid} not running. Cleaning up."
            rm -f "${FRITURE_PID_FILE}"
        fi
    else
        # Fallback: kill by process name
        if pgrep -f "friture" &>/dev/null; then
            pkill -f "friture"
            log "  Friture killed by process name."
        else
            log "  No running Friture instance found."
        fi
    fi
}

# =============================================================================
# MAIN LAUNCH
# =============================================================================
do_exec() {
    init_dirs
    log "========================================"
    log "  ${SCRIPT_NAME} ${SCRIPT_VERSION} – START"
    log "========================================"

    # Step 1 – Check installation root
    step "Checking fixed installation root"
    check_install_root

    # Step 2 – Check venv
    step "Verifying venv at ${VENV_DIR}"
    if [[ ! -d "${VENV_DIR}" || ! -f "${VENV_DIR}/bin/activate" ]]; then
        log "[ERROR] venv not found. Run: ${INSTALL_ROOT}/install.sh --exec"
        exit 1
    fi
    log "  venv OK"

    # Step 3 – Check Blue Yeti
    step "Checking Blue Yeti ALSA device"
    if arecord -l 2>/dev/null | grep -qi "Yeti"; then
        log "  ${YETI_NAME} detected – OK"
    else
        log "  [WARN] ${YETI_NAME} not found by ALSA. Select input manually in Friture."
    fi

    # Step 4 – Activate venv
    step "Activating venv"
    if [[ "${SIMULATE}" == true ]]; then
        log "[SIMULATE] Would activate: source ${VENV_DIR}/bin/activate"
    else
        # shellcheck disable=SC1090
        source "${VENV_DIR}/bin/activate"
        log "  venv activated"
    fi

    # Step 5 – Launch Friture
    step "Launching Friture"
    if [[ "${SIMULATE}" == true ]]; then
        log "[SIMULATE] Would run: friture"
    else
        log "  Starting Friture..."
        friture &
        local pid=$!
        echo "${pid}" > "${FRITURE_PID_FILE}"
        log "  Friture launched (PID ${pid})"
        log "  PID stored in ${FRITURE_PID_FILE}"
        log "  Stop with: ./${SCRIPT_NAME} --stop"
        wait "${pid}" || true
    fi

    log "========================================"
    log "  ${SCRIPT_NAME} – END"
    log "========================================"

    echo ""
    echo "Actions performed:"
    echo "  1. Installation root policy check"
    echo "  2. venv existence verified"
    echo "  3. Blue Yeti ALSA check"
    echo "  4. venv activated"
    echo "  5. Friture launched"
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
            check_prereqs
            exit $?
            ;;
        --install|-i)
            init_dirs
            do_install
            exit 0
            ;;
        --stop|-st)
            init_dirs
            do_stop
            exit 0
            ;;
        --simulate|-s)
            SIMULATE=true
            ;;
        --exec|-exe)
            DO_EXEC=true
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
    do_exec
fi
