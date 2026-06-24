# --- app.py ---
from dotenv import load_dotenv
load_dotenv()  # Carga la API Key desde el archivo .env [os]

# Importamos las funciones de tus otros dos archivos locales
from indexer import indexar_documentos
from query import responder_pregunta

import gradio as gr


# 1. Indexamos el PDF en memoria RAM una sola vez al iniciar la aplicación
# Reemplazá por "principito.pdf" o el manual que quieras usar
print("[PROCESO] Inicializando base de datos en RAM...")
db = indexar_documentos("principito.pdf")#, "./mi_base_vectorial")
print("[PROCESO] Base de datos lista. Iniciando interfaz visual...")

# 2. Definimos la función que conectará Gradio con tu RAG desacoplado
def chat_interfaz(mensaje_usuario, historial):
    """
    Gradio requiere que esta función reciba el mensaje actual y el historial,
    y que retorne la respuesta del bot en texto plano.
    """
    if not mensaje_usuario.strip():
        return ""
    
    # Llamamos a tu función del archivo query.py pasándole la DB en RAM
    respuesta_bot = responder_pregunta(mensaje_usuario, db)
    return respuesta_bot

# 3. Construimos la interfaz web usando el componente nativo de Chat
with gr.Blocks() as demo:
    gr.Markdown("# 🤖 Mi Asistente RAG Local")
    gr.Markdown("Consultá en tiempo real sobre el documento indexado en la memoria RAM.")
    
    # Componente oficial de chat interactivo (Gradio 6.0+)
    gr.ChatInterface(
        fn=chat_interfaz,
        textbox=gr.Textbox(placeholder="Escribí tu pregunta sobre el libro acá...", container=False, scale=7),
        submit_btn="Enviar",
        # Cambiado clear_btn por type_btn correspondiente o eliminado si no se usa
        # Nota: En Gradio 6.0, para modificar los botones de control por defecto se usa el parámetro 'show_buttons'
    )

# 4. Lanzamos el servidor web local
if __name__ == "__main__":
    # Pasamos el tema visual dentro del método launch()
    demo.launch(share=False, theme=gr.themes.Soft())
