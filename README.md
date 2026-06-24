# 🧠 RAG — Retrieval Augmented Generation

**Materia:** Procesamiento de Lenguaje Natural — Nivel Terciario

Repositorio educativo con ejemplos progresivos de sistemas RAG (Retrieval Augmented Generation), desde fundamentos teóricos hasta aplicaciones deployables con interfaz gráfica.

---

## 📁 Estructura del repositorio

```
ejemplo_simple/
├── 00_introduccion/       # Notebooks teórico-prácticos (Google Colab)
├── 01_monolitico/         # Versión mínima: todo en un archivo
├── 02_desacoplado/        # Versión modular: indexación + consulta separados
├── 03_ui_gradio/          # Interfaz web con Gradio (deployable en HF Spaces)
├── 04_ui_streamlit/       # Interfaz web con Streamlit (deployable en Streamlit Cloud)
└── README.md
```

---

## 📚 00_introducción — Notebooks introductorios

Seis notebooks diseñados para Google Colab que cubren todo el pipeline RAG:

| Notebook | Contenido |
|---|---|
| **00A_intro_RAG.ipynb** | Conceptos fundamentales: alucinación, loop autoregresivo, softmax + temperature, pipeline RAG completo con OpenAI |
| **00B_intro_RAG_gratuito.ipynb** | Versión gratuita usando modelos open-source (sentence-transformers all-MiniLM-L6-v2) sin depender de APIs de pago |
| **01_experimento_chunking.ipynb** | Experimentos con chunking: tamaño (200/500/1000 chars), overlap, estrategias (fijo/oración/párrafo/recursivo) |
| **02_experimento_embeddings.ipynb** | TF-IDF vs Embeddings semánticos: comparación empírica, búsqueda híbrida |
| **03_experimento_prompt_engineering.ipynb** | Ingeniería de prompts: sin instrucciones vs precisas, formato de salida, control de alucinación, Chain of Thought |
| **04_experimento_temperature.ipynb** | Efecto de la temperature, comparación de modelos (gpt-4o-mini vs gpt-4o), proyección de costos a escala |

**Tecnologías:** OpenAI API, ChromaDB, sentence-transformers, scikit-learn (TF-IDF)

---

## 🏗️ Proyectos de aplicación

### 01_monolitico — Versión monolítica

Un único archivo (`monolitico.py`) que contiene tanto la indexación como la consulta RAG. Ideal para entender el pipeline completo sin abstracciones.

```bash
cd 01_monolitico
pip install langchain-community langchain-text-splitters langchain-groq langchain-huggingface langchain-core chromadb pypdf python-dotenv sentence-transformers
python monolitico.py
```

**Requiere:** archivo `.env` con `GROQ_API_KEY` y un PDF (ej. `principito.pdf`).

---

### 02_desacoplado — Versión modular

Separa la lógica en tres archivos con responsabilidades claras:

- **`indexer.py`** — Carga, fragmenta (chunking) e indexa documentos en ChromaDB
- **`query.py`** — Realiza la consulta RAG (recuperación + generación)
- **`main.py`** — Orquestador que integra ambos módulos

```bash
cd 02_desacoplado
pip install langchain-community langchain-text-splitters langchain-groq langchain-huggingface langchain-core chromadb pypdf python-dotenv sentence-transformers
python main.py
```

**Requiere:** archivo `.env` con `GROQ_API_KEY` y un PDF.

---

### 03_ui_gradio — Interfaz con Gradio

Aplicación web con interfaz de chat usando **Gradio**. Indexa el PDF en RAM al iniciar y permite consultar en tiempo real.

```bash
cd 03_ui_gradio
pip install langchain-community langchain-text-splitters langchain-groq langchain-huggingface langchain-core chromadb pypdf python-dotenv sentence-transformers gradio
python app.py
```

**Requiere:** archivo `.env` con `GROQ_API_KEY` y un PDF.

#### ▶️ Deploy en Hugging Face Spaces

1. Crear un espacio en [huggingface.co/spaces](https://huggingface.co/spaces)
   - **SDK:** Gradio
   - **Space name:** el que prefieras
   - **Visibility:** público o privado según necesites

2. Subir los archivos del proyecto (`app.py`, `indexer.py`, `query.py`, el PDF y el `.gitignore`)

3. Agregar un archivo `requirements.txt`:

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

4. Configurar los **Secrets** del Space:
   - Ir a **Settings → Repository Secrets**
   - Agregar `GROQ_API_KEY` con tu clave de Groq (gratis en console.groq.com)

5. Subir el PDF que quieras indexar al repositorio del Space

6. El Space se construirá automáticamente y estará disponible en `https://huggingface.co/spaces/tu-usuario/tu-space`

---

### 04_ui_streamlit — Interfaz con Streamlit

Aplicación web con interfaz de chat usando **Streamlit**. Usa `@st.cache_resource` para indexar el PDF una sola vez en memoria.

```bash
cd 04_ui_streamlit
pip install langchain-community langchain-text-splitters langchain-groq langchain-huggingface langchain-core chromadb pypdf python-dotenv sentence-transformers streamlit
streamlit run app.py
```

**Requiere:** archivo `.env` con `GROQ_API_KEY` y un PDF.

#### ▶️ Deploy en Streamlit Cloud

1. Subir los archivos del proyecto (`app.py`, `indexer.py`, `query.py`, el PDF y el `.gitignore`) a un repositorio de **GitHub**

2. Ir a [Streamlit Community Cloud](https://streamlit.io/cloud) e iniciar sesión con tu cuenta de GitHub

3. Hacer clic en **"New app"** y conectar tu repositorio

4. Configurar:
   - **Repository:** el repositorio donde subiste los archivos
   - **Branch:** main (o la rama que uses)
   - **Main file path:** `04_ui_streamlit/app.py`

5. Agregar un archivo `requirements.txt` dentro de la carpeta `04_ui_streamlit/`:

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

6. Configurar los **Secrets**:
   - Ir a **Settings → Secrets** en Streamlit Cloud
   - Agregar `GROQ_API_KEY` con tu clave de Groq (gratis en console.groq.com)

7. También subir el PDF al repositorio (en la carpeta `04_ui_streamlit/`)

8. Hacer clic en **"Deploy"**

9. La app estará disponible en `https://tu-app-nombre.streamlit.app`

---

## 🔧 Stack tecnológico común

| Componente | Tecnología |
|---|---|
| **Lenguaje** | Python 3.10+ |
| **LLM** | Groq Llama-3.3-70b-versatile (vía `langchain-groq`) |
| **Embeddings** | `sentence-transformers/all-MiniLM-L6-v2` (local) |
| **Vector Store** | ChromaDB (en memoria) |
| **Carga de documentos** | PyPDFLoader (PDF), TextLoader (TXT), DirectoryLoader (carpetas) |
| **Chunking** | `RecursiveCharacterTextSplitter` (LangChain) |
| **Chains** | `create_retrieval_chain` + `create_stuff_documents_chain` |
| **Interfaz web** | Gradio (03) / Streamlit (04) |

---

## 🔑 Configuración inicial

Todos los proyectos requieren una clave de API de OpenAI. Creá un archivo `.env` en cada carpeta con:

```
GROQ_API_KEY=gsk-tu-api-key-acá
```

---

> ⚠️ **Nota sobre ChromaDB en Hugging Face Spaces:** El plan gratuito de HF Spaces tiene ~16 GB de RAM. ChromaDB en memoria es liviano, pero si indexás PDFs muy grandes (>100 páginas) podrías tener problemas de recursos. Para uso educativo con documentos pequeños no hay inconveniente.

> ⚠️ **Nota sobre `langchain-classic`:** Los imports del código usan `langchain_classic` (con guión bajo), un paquete que no está disponible en PyPI. Si al hacer deploy el entorno no lo encuentra, reemplazá las líneas:
> ```python
> from langchain_classic.chains import create_retrieval_chain
> from langchain_classic.chains.combine_documents import create_stuff_documents_chain
> ```
> por las versiones estándar de LangChain (ya comentadas en el código):
> ```python
> from langchain.chains import create_retrieval_chain
> from langchain.chains.combine_documents import create_stuff_documents_chain
> ```
> y eliminá `langchain-classic` del `requirements.txt`.

---

## 📈 Progresión pedagógica

```
00_introducción        → Conceptos teóricos + experimentos en Colab
       ↓
01_monolitico          → Pipeline completo en un solo archivo
       ↓
02_desacoplado         → Separación de responsabilidades (indexación/consulta)
       ↓
03_ui_gradio           → Interfaz gráfica + deploy en Hugging Face Spaces
       ↓
04_ui_streamlit        → Misma lógica, distinta UI + deploy en Streamlit Cloud
```

Cada nivel agrega una capa de complejidad y buenas prácticas de ingeniería, manteniendo el mismo núcleo RAG.
