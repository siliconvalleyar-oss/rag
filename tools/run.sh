#!/usr/bin/env bash
set -euo pipefail

# ──────────────────────────────────────────────
# CLI — PLN RAG Course
# ──────────────────────────────────────────────

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Detectar python del venv
if [ -f "$PROJECT_DIR/venv/bin/python3" ]; then
    VENV_PYTHON="$PROJECT_DIR/venv/bin/python3"
elif [ -f "$PROJECT_DIR/venv/Scripts/python.exe" ]; then
    VENV_PYTHON="$PROJECT_DIR/venv/Scripts/python.exe"
else
    VENV_PYTHON=python3
fi

menu_header() {
    clear
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  PLN RAG Course — Menú Principal"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

run_monolitico() {
    echo ""
    echo "▶ Ejecutando 01_monolitico/monolitico.py ..."
    cd "$PROJECT_DIR/01_monolitico"
    $VENV_PYTHON monolitico.py
    echo ""
    read -p "Presiona Enter para volver al menú..."
}

run_desacoplado() {
    echo ""
    echo "▶ Ejecutando 02_desacoplado/main.py ..."
    cd "$PROJECT_DIR/02_desacoplado"
    $VENV_PYTHON main.py
    echo ""
    read -p "Presiona Enter para volver al menú..."
}

run_gradio() {
    echo ""
    echo "▶ Iniciando 03_ui_gradio/app.py ..."
    cd "$PROJECT_DIR/03_ui_gradio"
    $VENV_PYTHON app.py
    echo ""
    read -p "Presiona Enter para volver al menú..."
}

run_streamlit() {
    echo ""
    echo "▶ Iniciando 04_ui_streamlit/app.py ..."
    cd "$PROJECT_DIR/04_ui_streamlit"
    $VENV_PYTHON -m streamlit run app.py
    echo ""
    read -p "Presiona Enter para volver al menú..."
}

index_documento() {
    echo ""
    echo "━━━ Indexar documento ━━━"
    echo "Seleccioná la versión:"
    echo "  1) 01_monolitico"
    echo "  2) 02_desacoplado"
    echo "  3) 03_ui_gradio"
    echo "  4) 04_ui_streamlit"
    read -p "Opción [1-4]: " ver

    read -p "Ruta del PDF (default: principito.pdf): " pdf_path
    pdf_path="${pdf_path:-principito.pdf}"

    case "$ver" in
        1) cd "$PROJECT_DIR/01_monolitico" ;;
        2) cd "$PROJECT_DIR/02_desacoplado" ;;
        3) cd "$PROJECT_DIR/03_ui_gradio" ;;
        4) cd "$PROJECT_DIR/04_ui_streamlit" ;;
        *) warn "Opción inválida"; return ;;
    esac

    $VENV_PYTHON -c "
from indexer import indexar_documentos
db = indexar_documentos('$pdf_path')
print(f'Indexado: {db._collection.count()} chunks')
"
    echo ""
    read -p "Presiona Enter para volver al menú..."
}

consulta_rapida() {
    echo ""
    echo "━━━ Consulta Rápida ━━━"
    read -p "Pregunta: " pregunta
    echo ""

    cd "$PROJECT_DIR/02_desacoplado"
    $VENV_PYTHON -c "
from indexer import indexar_documentos
from query import responder_pregunta
db = indexar_documentos('principito.pdf')
respuesta = responder_pregunta('$pregunta', db)
print('Respuesta:', respuesta)
"
    echo ""
    read -p "Presiona Enter para volver al menú..."
}

open_notebooks() {
    echo ""
    echo "▶ Abriendo notebooks en $PROJECT_DIR/00_introduccion ..."
    cd "$PROJECT_DIR/00_introduccion"
    # Buscar jupyter
    if command -v jupyter-notebook &>/dev/null; then
        jupyter-notebook &
    elif command -v jupyter &>/dev/null; then
        jupyter notebook &
    else
        warn "Jupyter no encontrado. Instalálo con: pip install jupyter"
    fi
    echo ""
    read -p "Presiona Enter para volver al menú..."
}

list_notebooks() {
    echo ""
    echo "━━━ Notebooks disponibles ━━━"
    for nb in "$PROJECT_DIR/00_introduccion"/*.ipynb; do
        echo "  • $(basename "$nb")"
    done
    echo ""
    read -p "Presiona Enter para volver al menú..."
}

show_info() {
    echo ""
    echo "━━━ Info del proyecto ━━━"
    echo "  Repositorio: https://github.com/siliconvalleyar-oss/rag"
    echo "  Tag actual:  v1.0.2"
    echo "  Python:      $($VENV_PYTHON --version 2>&1)"
    echo ""
    echo "  Estructura:"
    echo "    00_introduccion/   → 6 notebooks (teoría + experimentos)"
    echo "    01_monolitico/     → Pipeline RAG en un archivo"
    echo "    02_desacoplado/    → Versión modular (indexer + query)"
    echo "    03_ui_gradio/      → Interfaz web con Gradio"
    echo "    04_ui_streamlit/   → Interfaz web con Streamlit"
    echo "    docs/              → Documentación completa"
    echo "    RULES.md           → Reglas del proyecto"
    echo ""
    read -p "Presiona Enter para volver al menú..."
}

# ──────────────────────────────────────────────
# Principal
# ──────────────────────────────────────────────

while true; do
    menu_header
    echo ""
    echo "  ¿Qué querés hacer?"
    echo ""
    echo "  ── Ejecutar ──"
    echo "   1) 01_monolitico   — Pipeline completo (CLI)"
    echo "   2) 02_desacoplado  — Versión modular (CLI)"
    echo "   3) 03_ui_gradio    — Interfaz web Gradio"
    echo "   4) 04_ui_streamlit — Interfaz web Streamlit"
    echo ""
    echo "  ── Utilidades ──"
    echo "   5) Indexar un documento"
    echo "   6) Consulta rápida RAG"
    echo ""
    echo "  ── Notebooks ──"
    echo "   7) Abrir Jupyter notebooks"
    echo "   8) Listar notebooks"
    echo ""
    echo "  ── Info ──"
    echo "   9) Información del proyecto"
    echo "   0) Salir"
    echo ""
    read -p "Opción [0-9]: " opt

    case "$opt" in
        1) run_monolitico ;;
        2) run_desacoplado ;;
        3) run_gradio ;;
        4) run_streamlit ;;
        5) index_documento ;;
        6) consulta_rapida ;;
        7) open_notebooks ;;
        8) list_notebooks ;;
        9) show_info ;;
        0) echo ""; echo "Chau!"; exit 0 ;;
        *) warn "Opción inválida"; sleep 1 ;;
    esac
done
