# --- app_streamlit.py ---
import streamlit as st
from dotenv import load_dotenv
load_dotenv()  # [os]

from indexer import indexar_documentos
from query import responder_pregunta

# 1. Aplicamos el decorador de recursos para RAG / Bases de datos / Modelos
# Esto le dice a Streamlit: "Ejecutá esto una sola vez y guardalo en RAM para siempre"
@st.cache_resource
def inicializar_base_vectorial():
    print("[STREAMLIT] Indexando el PDF por única vez en caché...")
    return indexar_documentos("principito.pdf", ruta_db=None)

# Invocamos la función optimizada
db_viva = inicializar_base_vectorial()

# 2. Interfaz Gráfica de Streamlit
st.title("🤖 Mi Asistente RAG con Streamlit")

# Inicializar el historial de chat en la sesión si no existe
if "messages" not in st.session_state:
    st.session_state.messages = []

# Mostrar mensajes anteriores en pantalla
for message in st.session_state.messages:
    with st.chat_message(message["role"]):
        st.markdown(message["content"])

# Entrada del usuario (Chat Input)
if pregunta_usuario := st.chat_input("Escribí tu pregunta sobre el libro..."):
    # Mostrar la pregunta del usuario
    with st.chat_message("user"):
        st.markdown(pregunta_usuario)
    st.session_state.messages.append({"role": "user", "content": pregunta_usuario})

    # Generar la respuesta usando tu query.py desacoplado
    with st.chat_message("assistant"):
        # El db_viva viene directo de la caché de Streamlit sin haber reindexado
        respuesta_bot = responder_pregunta(pregunta_usuario, db_viva)
        st.markdown(respuesta_bot)
        
    st.session_state.messages.append({"role": "assistant", "content": respuesta_bot})
