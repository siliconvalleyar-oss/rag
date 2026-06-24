# Arquitectura del Sistema RAG

## Pipeline RAG

Todos los proyectos siguen el mismo pipeline RAG (Retrieval Augmented Generation):

```
Documento PDF
     │
     ▼
[1] Carga (PyPDFLoader)
     │
     ▼
[2] Chunking (RecursiveCharacterTextSplitter)
     │   chunk_size=1000, chunk_overlap=200
     ▼
[3] Embeddings (sentence-transformers/all-MiniLM-L6-v2)
     │
     ▼
[4] Vector Store (ChromaDB en memoria)
     │
     ▼
[5] Retrieval (k=3)
     │   Pregunta del usuario → busca chunks similares
     ▼
[6] Augmented Prompt
     │   System prompt + contexto recuperado + pregunta
     ▼
[7] Generation (Groq Llama-3.3-70b-versatile, temperature=0)
     │
     ▼
Respuesta al usuario
```

## Versiones

### 01_monolitico — Monolítica

Un solo archivo con todo el pipeline. Ideal para entender el flujo completo.

```
monolitico.py
├── indexar_documentos()  → carga PDF → chunking → embeddings → ChromaDB
└── responder_pregunta()  → retrieve → prompt → generate
```

### 02_desacoplado — Modular

Separa responsabilidades en 3 archivos:

```
main.py                   → orquestador (importa y ejecuta)
├── indexer.py            → indexar_documentos()
└── query.py              → responder_pregunta()
```

### 03_ui_gradio — Interfaz Gradio

```
app.py                    → UI Gradio + orquestación
├── indexer.py            → indexar_documentos()
└── query.py              → responder_pregunta()
```

### 04_ui_streamlit — Interfaz Streamlit

```
app.py                    → UI Streamlit + orquestación
├── indexer.py            → indexar_documentos()
└── query.py              → responder_pregunta()
```

## Flujo de datos

```
Pregunta usuario
      │
      ▼
Retriever (ChromaDB.as_retriever(k=3))
      │
      ├── chunk_1 (score similaridad)
      ├── chunk_2 (score similaridad)
      └── chunk_3 (score similaridad)
      │
      ▼
Prompt template:
  "Eres un asistente... Contexto: {context} Pregunta: {input}"
      │
      ▼
LLM (ChatGroq, model=llama-3.3-70b-versatile, temperature=0)
      │
      ▼
Respuesta
```

## ChatHistory (solo Gradio)

Gradio maneja el historial automáticamente via `gr.ChatInterface`. El historial se pasa como parámetro al callback pero no se utiliza activamente (cada consulta es independiente).

## Cache (solo Streamlit)

Usa `@st.cache_resource` para que la base vectorial se indexe una sola vez y se reutilice entre re-ejecuciones de Streamlit.
