#!/usr/bin/env bash
set -euo pipefail

# ──────────────────────────────────────────────
# Instalador multiplataforma (Linux/macOS/WSL)
# ──────────────────────────────────────────────

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

msg()   { echo -e "${GREEN}[✓]${NC} $1"; }
warn()  { echo -e "${YELLOW}[!]${NC} $1"; }
err()   { echo -e "${RED}[✗]${NC} $1"; }

detect_os() {
    case "$(uname -s)" in
        Linux*)   echo "linux" ;;
        Darwin*)  echo "macos" ;;
        MINGW*|MSYS*|CYGWIN*) echo "windows" ;;
        *)        echo "unknown" ;;
    esac
}

check_python() {
    if command -v python3 &>/dev/null; then
        PYTHON=python3
    elif command -v python &>/dev/null; then
        PYTHON=python
    else
        err "Python no encontrado. Instalá Python 3.10+ primero."
        exit 1
    fi

    version=$("$PYTHON" --version 2>&1 | grep -oP '\d+\.\d+')
    msg "Python $version detectado"
}

check_pip() {
    if ! command -v pip3 &>/dev/null && ! command -v pip &>/dev/null; then
        warn "pip no encontrado — intentando instalarlo..."
        "$PYTHON" -m ensurepip --upgrade
    fi

    if command -v pip3 &>/dev/null; then
        PIP=pip3
    else
        PIP=pip
    fi
    msg "pip listo"
}

create_venv() {
    local dir="$1"
    if [ ! -d "$dir/venv" ]; then
        warn "Creando entorno virtual en $dir/venv ..."
        "$PYTHON" -m venv "$dir/venv"
        msg "Entorno virtual creado"
    else
        msg "Entorno virtual ya existe en $dir/venv"
    fi
}

install_deps() {
    local dir="$1"
    local os="$2"

    if [ "$os" = "windows" ]; then
        VENV_PYTHON="$dir/venv/Scripts/python.exe"
        VENV_PIP="$dir/venv/Scripts/pip.exe"
    else
        VENV_PYTHON="$dir/venv/bin/python3"
        VENV_PIP="$dir/venv/bin/pip3"
    fi

    warn "Instalando dependencias en $dir/venv ..."
    "$VENV_PIP" install --upgrade pip
    "$VENV_PIP" install -r "$dir/requirements.txt"
    msg "Dependencias instaladas"
}

# ──────────────────────────────────────────────
# Main
# ──────────────────────────────────────────────

OS=$(detect_os)
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Instalador — PLN RAG Course"
echo "  OS: $OS"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

check_python
check_pip

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
create_venv "$PROJECT_DIR"
install_deps "$PROJECT_DIR" "$OS"

msg "Instalación completada."
echo ""
echo "Para activar el entorno:"
if [ "$OS" = "windows" ]; then
    echo "  source $PROJECT_DIR/venv/Scripts/activate"
else
    echo "  source $PROJECT_DIR/venv/bin/activate"
fi
echo ""

case "$OS" in
    linux)   msg "Linux detectado — todo listo" ;;
    macos)   msg "macOS detectado — todo listo" ;;
    windows) msg "Windows detectado — asegurate de tener Git Bash o WSL" ;;
    *)       warn "SO desconocido — la instalación puede requerir pasos manuales" ;;
esac
