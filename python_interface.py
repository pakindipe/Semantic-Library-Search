from sentence_transformers import SentenceTransformer
import faiss
import numpy as np
from sklearn.preprocessing import normalize
import sys
titles = ["Journeys Beyond the Horizon",
          "The Edge of the Map",
          "Explorers of the Unknown",
          "Into the Farthest Lands",
          "The Path of Discovery",
          "The Depths of Thought",
          "Horizons of the Mind",
          "The Nature of Knowing",
          "Reflections on Reality",
          "The Infinite Within"]
model = SentenceTransformer("sentence-transformers/all-MiniLM-L6-v2")
embs = model.encode(titles, batch_size=64, convert_to_numpy=True)
embs = normalize(embs)

d = 384

index = faiss.IndexFlatIP(d)
index.add(embs)

def query(query:str):
    query_vec = model.encode([query], convert_to_numpy=True).astype("float32")
    query_vec = normalize(query_vec)
    D, I = index.search(query_vec, 5)
    ordered_titles = []
    for ind in I[0]:
        ordered_titles.append(titles[ind])
    return ordered_titles


if len(sys.argv) > 1:
    result = query(sys.argv[1])
    for r in result:
        print(r)    