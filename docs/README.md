# RAG — Retrieval Augmented Generation

**Materia:** Procesamiento de Lenguaje Natural — Nivel Terciario

Repositorio educativo con ejemplos progresivos de sistemas RAG (Retrieval Augmented Generation), desde fundamentos teóricos hasta aplicaciones deployables con interfaz gráfica.

## Estructura

```
clase_pln_1106/
├── 00_introduccion/       # Notebooks teórico-prácticos (Google Colab)
├── 01_monolitico/         # Versión mínima: todo en un archivo
├── 02_desacoplado/        # Versión modular: indexación + consulta separados
├── 03_ui_gradio/          # Interfaz web con Gradio (deployable en HF Spaces)
├── 04_ui_streamlit/       # Interfaz web con Streamlit (deployable en Streamlit Cloud)
├── docs/                  # Documentación del proyecto
└── README.md
```

## Progresión pedagógica

```
00_introduccion        → Conceptos teóricos + experimentos en Colab
       ↓
01_monolitico          → Pipeline completo en un solo archivo
       ↓
02_desacoplado         → Separación de responsabilidades (indexación/consulta)
       ↓
03_ui_gradio           → Interfaz gráfica + deploy en Hugging Face Spaces
       ↓
04_ui_streamlit        → Misma lógica, distinta UI + deploy en Streamlit Cloud
```

## Stack tecnológico

| Componente | Tecnología |
|---|---|
| Lenguaje | Python 3.10+ |
| LLM | Groq (Llama-3.3-70b-versatile / Mixtral) vía API gratuita |
| Embeddings | Sentence Transformers all-MiniLM-L6-v2 (local, gratuito) |
| Vector Store | ChromaDB (en memoria) |
| Chunking | RecursiveCharacterTextSplitter |
| Carga de documentos | PyPDFLoader / TextLoader / DirectoryLoader |
| RAG Chains | create_retrieval_chain + create_stuff_documents_chain |
| API Key | GROQ_API_KEY (gratis en console.groq.com) |
| UI (opción 1) | Gradio → Hugging Face Spaces |
| UI (opción 2) | Streamlit → Streamlit Cloud |
