from sentence_transformers import SentenceTransformer
import faiss
import numpy as np
import pandas as pd
from sklearn.preprocessing import normalize
import sys
import sqlite3

df = pd.read_csv("books_dataset.csv")
model = SentenceTransformer("sentence-transformers/all-MiniLM-L6-v2")
d = 384
index = faiss.IndexIDMap(faiss.IndexFlatIP(d))

def _conn():
    c = sqlite3.connect("books.db")
    c.row_factory = sqlite3.Row
    return c

schema = """
DROP TABLE IF EXISTS books;

CREATE TABLE books (
id INTEGER PRIMARY KEY,
title TEXT NOT NULL,
author TEXT,
genre TEXT,
year_published INTEGER, 
availability BOOLEAN
);
"""
with _conn() as c:
    c.executescript(schema)

with _conn() as c:
    for ind, row in df.iterrows():
        emb = model.encode(row["title"])
        emb = normalize(emb.reshape(1, -1)).astype("float32")
        id = np.array([ind], dtype=np.int64)
        index.add_with_ids(emb, id)
        query = """
        INSERT INTO books (id, title, author, genre, year_published, availability)
        VALUES
        (?, ?, ?, ?, ?, 1)
        """
        metadata = (ind, row["title"], row["author"], row["genre"], row["year"])
        c.execute(query, metadata)

faiss.write_index(index, "book_embeddings.faiss")
