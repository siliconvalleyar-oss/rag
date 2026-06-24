# Deploy

## Deploy Gradio en Hugging Face Spaces

1. Crear espacio en [huggingface.co/spaces](https://huggingface.co/spaces)
   - SDK: Gradio
   - Space name: el que prefieras

2. Subir archivos de `03_ui_gradio/`:
   - `app.py`
   - `indexer.py`
   - `query.py`
   - `principito.pdf` (o cualquier PDF)
   - `.gitignore`
   - `requirements.txt`:
     ```
     langchain-community
     langchain-text-splitters
     langchain-groq
     langchain-huggingface
     sentence-transformers
     langchain-classic
     langchain-core
     chromadb
     pypdf
     python-dotenv
     gradio
     ```

3. Configurar Secrets:
   - Settings → Repository Secrets
   - `GROQ_API_KEY` = tu clave de Groq (gratis en console.groq.com)

4. El Space se construye automáticamente.

---

## Deploy Streamlit en Streamlit Cloud

1. Subir `04_ui_streamlit/` a un repositorio de GitHub

2. Ir a [streamlit.io/cloud](https://streamlit.io/cloud)

3. New app → conectar repositorio

4. Configurar:
   - Main file path: `04_ui_streamlit/app.py`

5. `requirements.txt` dentro de `04_ui_streamlit/`:
   ```
   langchain-community
   langchain-text-splitters
   langchain-groq
   langchain-huggingface
   sentence-transformers
   langchain-classic
   langchain-core
   chromadb
   pypdf
   python-dotenv
   streamlit
   ```

6. Secrets en Streamlit Cloud:
   - Settings → Secrets
   - `GROQ_API_KEY` = tu clave de Groq (gratis en console.groq.com)

---

## Notas importantes

- ChromaDB corre en memoria. El plan gratuito de HF Spaces tiene ~16 GB RAM.
- Si `langchain-classic` no está disponible, reemplazar imports por `langchain.chains`.
- El PDF se indexa al iniciar la aplicación (puede tomar unos segundos).
- La base vectorial se pierde al detener la app (no hay persistencia).
