# --- SCRIPT DE CONSULTA (query.py) ---
from langchain_community.vectorstores import Chroma
from langchain_openai import OpenAIEmbeddings, ChatOpenAI
# from langchain.chains import create_retrieval_chain
# from langchain.chains.combine_documents import create_stuff_documents_chain
from langchain_classic.chains import create_retrieval_chain
from langchain_classic.chains.combine_documents import create_stuff_documents_chain
from langchain_core.prompts import ChatPromptTemplate


from dotenv import load_dotenv
load_dotenv() 

def responder_pregunta(pregunta_usuario: str, db):
    # 1. Conectar a la base de datos vectorial existente
    #embeddings = OpenAIEmbeddings(model="text-embedding-3-small")
    #vector_store = Chroma(persist_directory=ruta_db, embedding_function=embeddings)
    
    # Configurar el recuperador (ej. traer los 3 fragmentos más relevantes)
    #retriever = vector_store.as_retriever(search_kwargs={"k": 3})

    # Si queremos tomar datos desde una bbdd NO persistente
    retriever = db.as_retriever(search_kwargs={"k": 3})

    # 2. Definir el prompt del sistema (Reglas estrictas para evitar alucinaciones)
    system_prompt = (
        "Eres un asistente experto. Responde la pregunta del usuario utilizando "
        "únicamente el siguiente contexto proporcionado. Si no sabes la respuesta "
        "o no está en el contexto, di que no lo sabes, no inventes información.\n\n"
        "Contexto:\n{context}"
    )
    
    prompt = ChatPromptTemplate.from_messages([
        ("system", system_prompt),
        ("human", "{input}"),
    ])
    
    # 3. Configurar el LLM y las cadenas de ejecución (Chains)
    llm = ChatOpenAI(model="gpt-4o-mini", temperature=0) # Temperatura 0 para ser más preciso
    
    combine_docs_chain = create_stuff_documents_chain(llm, prompt)
    rag_chain = create_retrieval_chain(retriever, combine_docs_chain)
    
    # 4. Ejecutar la consulta
    resultado = rag_chain.invoke({"input": pregunta_usuario})
    
    return resultado["answer"]