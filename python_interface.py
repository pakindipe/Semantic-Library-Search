from sentence_transformers import SentenceTransformer
import numpy as np
titles = []
embs = None
model = SentenceTransformer("sentence-transformers/all-MiniLM-L6-v2")

def normalize(vec):
    return vec / (np.linalg.norm(vec) + 1e-12)

def add_book(title:str):
    global embs
    titles.append(title)
    vec = model.encode(title, convert_to_numpy=True).astype("float32")
    vec = normalize(vec)
    embs = vec if embs is None else np.vstack([embs, vec])

def query(query:str):
    query_vec = model.encode(query, convert_to_numpy=True).astype("float32")
    query_vec = normalize(query_vec)
    scores = embs @ query_vec
    idx = np.argsort(-scores)
    ordered_titles = titles[idx]
    return ordered_titles[0:5]

add_book("Journeys Beyond the Horizon")
add_book("The Edge of the Map")
add_book("Explorers of the Unknown")
add_book("Into the Farthest Lands")
add_book("The Path of Discovery")
add_book("The Depths of Thought")
add_book("Horizons of the Mind")
add_book("The Nature of Knowing")
add_book("Reflections on Reality")
add_book("The Infinite Within")

results = query("How we think")
for title in results:
    print(title)