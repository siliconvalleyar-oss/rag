# Setup y configuración

## Requisitos

- Python 3.10+
- pip
- Cuenta de OpenAI (para API key)

## Instalación global

```bash
pip install -r requirements.txt
```

## Configurar API key

Crear archivo `.env` en cada carpeta de proyecto:

```
GROQ_API_KEY=gsk-tu-api-key-acá
```

Obtener tu key gratis en [console.groq.com/keys](https://console.groq.com/keys).

## Ejecutar cada versión

### 01_monolitico

```bash
cd 01_monolitico
python monolitico.py
```

### 02_desacoplado

```bash
cd 02_desacoplado
python main.py
```

### 03_ui_gradio

```bash
cd 03_ui_gradio
python app.py
```

Abre en el navegador la URL que muestra Gradio (ej. `http://127.0.0.1:7860`).

### 04_ui_streamlit

```bash
cd 04_ui_streamlit
streamlit run app.py
```

Abre en el navegador la URL que muestra Streamlit.

## Notebooks (00_introduccion)

Los notebooks están diseñados para Google Colab:
1. Subir a [colab.research.google.com](https://colab.research.google.com)
2. Para `00A_intro_RAG.ipynb`: configurar `OPENAI_API_KEY` como secret de Colab
3. Para `00B_intro_RAG_gratuito.ipynb`: no requiere API key

## Troubleshooting

### `langchain-classic` no encontrado

Reemplazar en `indexer.py` y `query.py`:

```python
from langchain_classic.chains import create_retrieval_chain
from langchain_classic.chains.combine_documents import create_stuff_documents_chain
```

por:

```python
from langchain.chains import create_retrieval_chain
from langchain.chains.combine_documents import create_stuff_documents_chain
```

Y eliminar `langchain-classic` del `requirements.txt`.

### ChromaDB en Hugging Face Spaces

El plan gratuito tiene ~16 GB de RAM. ChromaDB en memoria es liviano, pero para PDFs muy grandes (>100 págs.) puede haber problemas.
