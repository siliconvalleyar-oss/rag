# Módulos del sistema RAG

## indexer.py (compartido entre 02, 03, 04)

### `indexar_documentos(ruta_pdf, ruta_db=None)` → `Chroma`

Carga un PDF, lo divide en chunks y lo indexa en ChromaDB.

| Parámetro | Tipo | Default | Descripción |
|-----------|------|---------|-------------|
| `ruta_pdf` | `str` | — | Ruta al archivo PDF |
| `ruta_db` | `str` o `None` | `None` | Ruta opcional para persistir ChromaDB. `None` = en memoria |

**Pipeline interno:**
1. `PyPDFLoader(ruta_pdf).load()` → carga el PDF
2. `RecursiveCharacterTextSplitter(chunk_size=1000, chunk_overlap=200).split_documents()` → divide en chunks
3. `HuggingFaceEmbeddings(model_name="sentence-transformers/all-MiniLM-L6-v2")` → genera embeddings locales
4. `Chroma.from_documents(docs, embedding)` → almacena y retorna el vector store

---

## query.py (compartido entre 02, 03, 04)

### `responder_pregunta(pregunta_usuario, db)` → `str`

Ejecuta una consulta RAG: recupera chunks relevantes y genera respuesta.

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `pregunta_usuario` | `str` | Pregunta del usuario |
| `db` | `Chroma` | Vector store con los documentos indexados |

**Pipeline interno:**
1. `db.as_retriever(search_kwargs={"k": 3})` → recupera los 3 chunks más similares
2. Prompt template con sistema + contexto + pregunta
3. `ChatOpenAI(model="gpt-4o-mini", temperature=0)` → genera respuesta
4. `create_retrieval_chain(retriever, chain)` → encadena recuperación + generación

**System prompt:**

```
Eres un asistente especializado en responder preguntas.
Usa SOLO la información del contexto proporcionado para responder.
Si no encuentras la respuesta en el contexto, responde:
"No tengo información suficiente para responder esta pregunta."
No inventes información.
```

---

## monolitico.py (01_monolitico)

Combina `indexar_documentos()` y `responder_pregunta()` en un solo archivo. Idéntica lógica a los módulos separados.

Funciones:
- `indexar_documentos(ruta_pdf, ruta_db=None)` → `Chroma`
- `responder_pregunta(pregunta_usuario, db)` → `str`

Incluye al final del archivo un bloque `if __name__ == "__main__":` que ejecuta el pipeline completo de ejemplo.

---

## app.py (Gradio) — 03_ui_gradio

### Flujo:

```python
# Al iniciar:
db = indexar_documentos("principito.pdf")   # indexa una vez

# Por cada mensaje:
def chat_interfaz(mensaje_usuario, historial):
    return responder_pregunta(mensaje_usuario, db)
```

**UI:** `gr.ChatInterface` con theme `gr.themes.Soft()`.

---

## app.py (Streamlit) — 04_ui_streamlit

### Flujo:

```python
# Al iniciar (cacheado):
@st.cache_resource
def inicializar_base_vectorial():
    return indexar_documentos("principito.pdf")

# Por cada mensaje:
respuesta = responder_pregunta(pregunta, db_viva)
```

**UI:** `st.chat_message()` + `st.chat_input()` con session state para historial.

---

## main.py (02_desacoplado)

Orquestador mínimo:

```python
load_dotenv()
db = indexar_documentos("principito.pdf")
respuesta = responder_pregunta("¿Que es lo invisible ?", db)
print(respuesta)
```
