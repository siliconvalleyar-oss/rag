# --- main.py ---
from dotenv import load_dotenv
load_dotenv()  # Carga la API Key desde el archivo .env [os]

# Importamos las funciones de tus otros dos archivos locales
from indexer import indexar_documentos
from query import responder_pregunta

# Uso del script
db = indexar_documentos("principito.pdf")#, "./mi_base_vectorial")
respuesta = responder_pregunta("¿Que es lo invisible ?", db) #"./mi_base_vectorial")
print(respuesta)

