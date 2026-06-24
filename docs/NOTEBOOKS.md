# Notebooks — 00_introduccion

Diseñados para Google Colab. Cubren teoría y experimentos prácticos sobre RAG.

## 00A_intro_RAG.ipynb — Introducción a RAG (OpenAI)

Conceptos fundamentales del pipeline RAG usando OpenAI (requiere API key).

- Por qué los LLM alucinan (knowledge cutoff, falta de contexto privado)
- Loop autoregresivo: cómo genera tokens un LLM
- Softmax + temperature: distribución de probabilidad
- Pipeline RAG completo: chunking → embeddings → vector store → retrieval → generation
- Comparación: con RAG vs sin RAG
- Más allá de RAG: Context Stuffing, Fine-tuning, Agents

**Requiere:** `OPENAI_API_KEY`
**Librerías:** `openai`, `tiktoken`, `chromadb`, `sentence-transformers`

---

## 00B_intro_RAG_gratuito.ipynb — Introducción a RAG (Open-Source)

Mismo contenido que 00A pero completamente gratuito. Sin API keys.

- LLM local: Qwen2.5-1.5B-Instruct (Hugging Face)
- Embeddings locales: Sentence Transformers all-MiniLM-L6-v2
- Softmax con numpy
- Temperature con modelo local

**Requiere:** Nada (todo corre en CPU o T4 gratis de Colab)

---

## 01_experimento_chunking.ipynb — Experimentos de Chunking

4 experimentos sobre estrategias de fragmentación:

1. **Tamaño de chunk:** 200 vs 500 vs 1000 caracteres
2. **Overlap:** 0% vs 20%
3. **Estrategias:** Fijo (chars) vs Oración vs Párrafo vs Recursivo
4. **Impacto en respuesta final:** cómo el chunking afecta la calidad de la respuesta

**Conclusión:** No existe un tamaño único "correcto". Depende del tipo de documento y las preguntas esperadas.

---

## 02_experimento_embeddings.ipynb — TF-IDF vs Embeddings Semánticos

Compara búsqueda léxica (TF-IDF) vs semántica (embeddings).

1. **Preguntas léxicas:** TF-IDF funciona bien (coincidencia de palabras clave)
2. **Preguntas semánticas:** Embeddings encuentran significado sin palabras compartidas
3. **Visualización:** Matriz sparse TF-IDF vs vector denso 1536-dim
4. **Similaridad semántica directa:** Tabla comparativa pairwise
5. **Búsqueda híbrida:** Combinando ambos enfoques

**Conclusión:** TF-IDF encuentra tokens; Embeddings encuentran significado. Híbrido es lo óptimo.

---

## 03_experimento_prompt_engineering.ipynb — Ingeniería de Prompts

5 experimentos sobre cómo el prompt afecta la salida del LLM:

1. **Sin instrucciones:** Comportamiento impredecible
2. **Instrucciones vagas vs precisas:** 3 niveles de especificidad
3. **Control de formato:** Texto libre vs JSON vs Lista vs Corto vs Informal
4. **Manejo de información faltante:** Control de alucinación
5. **Chain of Thought (CoT):** Razonamiento paso a paso

**Conclusión:** Incluso con recuperación perfecta, un mal prompt produce malas respuestas.

---

## 04_experimento_temperature.ipynb — Temperature y Modelos

3 experimentos sobre configuración del LLM:

1. **Efecto de temperature:** 0.0 vs 0.3 vs 0.7 vs 1.2
2. **Comparación de modelos:** gpt-4o-mini ($0.15/M) vs gpt-4o ($2.50/M)
3. **Proyección de costos:** Análisis de costos a escala

**Conclusión:** Para RAG en producción, temperature 0.0-0.3. gpt-4o-mini es 16x más barato y suficiente para consultas simples.
