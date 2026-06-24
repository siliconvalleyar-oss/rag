from langchain_community.document_loaders import PyPDFLoader, TextLoader, DirectoryLoader
from langchain_text_splitters import RecursiveCharacterTextSplitter
from langchain_huggingface import HuggingFaceEmbeddings
from langchain_community.vectorstores import Chroma
from typing import Optional

from dotenv import load_dotenv
load_dotenv() 

def indexar_documentos(ruta_pdf: str, ruta_db: Optional[str] = None):
    # 1. Cargar el documento
    
    # Depende que tipo de archivos uso para PFD o para TXT
    loader = PyPDFLoader(ruta_pdf)
    #loader = TextLoader(ruta_txt, encoding="utf-8")

    # Y si queremos cargar una carpeta con archivos
    #loader = DirectoryLoader(
    #path="./mi_carpeta",
    #glob="**/*.txt",          # Busca solo TXTs cambiar a .pdf
    #loader_cls=TextLoader,    # Usa el lector de TXTs cambiar a PyPDFLoader para pdf
    #loader_kwargs={"encoding": "utf-8"} # Configuración extra que necesita el TextLoader
#)

    documentos = loader.load()
    
    # 2. Fragmentar el texto (Evita perder contexto configurando el solapamiento)
    text_splitter = RecursiveCharacterTextSplitter(
        chunk_size=1000,       # Tamaño del fragmento (caracteres)
        chunk_overlap=200      # Solapamiento para mantener el contexto entre fragmentos
    )
    fragmentos = text_splitter.split_documents(documentos)

    #Si quisiera que cada documento sea un único chunk, no paso el Splitter

    #fragmentos = loader.load()

    # Tener en cuenta que:

    # Límite de tokens del modelo de Embeddings: El modelo text-embedding-3-small de OpenAI tiene un límite máximo de 8191 tokens por inserción (aproximadamente unas 6000 palabras o unas 12-15 páginas de texto plano). Si tu archivo .txt supera este tamaño, el código arrojará un error de la API de OpenAI porque el vectorizador no podrá procesar un bloque tan gigante de una sola vez.

    # Límite de la ventana de contexto del LLM: Cuando ejecutes la consulta, tu retriever buscará los documentos más relevantes. Si configuraste k=3 en tu script de consulta, el sistema intentará meter 3 archivos TXT completos dentro del prompt del LLM. Asegurate de que tu modelo (como gpt-4o-mini) tenga espacio suficiente en su ventana de contexto para procesar semejante volumen de texto sin truncar la información.


    
    # 3 y 4. Generar Embeddings y guardar en la base de datos vectorial
    embeddings = HuggingFaceEmbeddings(model_name="sentence-transformers/all-MiniLM-L6-v2")
    
    # Esto crea la base de datos localmente y guarda los vectores
    vector_store = Chroma.from_documents(
        documents=fragmentos, 
        embedding=embeddings, 
        #persist_directory=ruta_db solo si quiero que la bd sea persistente
    )
    print(f"Indexación completada. {len(fragmentos)} fragmentos guardados.")
    return vector_store 

# Uso del script
#db = indexar_documentos("principito.pdf")#, "./mi_base_vectorial")
#quit()