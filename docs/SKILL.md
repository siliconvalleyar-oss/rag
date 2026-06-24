# Skill: PLN RAG Course

## Descripción

Curso educativo de Procesamiento de Lenguaje Natural (PLN) enfocado en sistemas RAG (Retrieval Augmented Generation). Progresión desde conceptos teóricos hasta aplicaciones deployables.

## Archivos clave

| Archivo | Propósito |
|---------|-----------|
| `01_monolitico/monolitico.py` | Pipeline RAG completo en un archivo |
| `02_desacoplado/indexer.py` | Módulo de indexación de documentos |
| `02_desacoplado/query.py` | Módulo de consulta RAG |
| `02_desacoplado/main.py` | Orquestador CLI |
| `03_ui_gradio/app.py` | Interfaz web con Gradio |
| `04_ui_streamlit/app.py` | Interfaz web con Streamlit |
| `00_introduccion/` | 6 notebooks de teoría y experimentos |

## Endpoints

No hay endpoints HTTP. Cada versión expone:
- CLI: `python main.py` (02_desacoplado)
- Web UI: Gradio en `localhost:7860` (03_ui_gradio)
- Web UI: Streamlit en `localhost:8501` (04_ui_streamlit)

## Dependencias

Ver `requirements.txt`.

## Comandos útiles

```bash
# Instalar
pip install -r requirements.txt

# Ejecutar versión CLI
cd 01_monolitico && python monolitico.py

# Ejecutar versión Gradio
cd 03_ui_gradio && python app.py

# Ejecutar versión Streamlit
cd 04_ui_streamlit && streamlit run app.py
```

## Configuración

Requiere `GROQ_API_KEY` en archivo `.env` dentro de cada carpeta de proyecto. Conseguila gratis en https://console.groq.com/keys.
