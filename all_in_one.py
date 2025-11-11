from sentence_transformers import SentenceTransformer
import numpy as np
import sys, json
import faiss
from pathlib import Path
import sqlite3

class DB:
    def __init__(self, path="books.db"):
        self.path = Path(path)
        self._init_schema()

    def _conn(self):
        c = sqlite3.connect(self.path)
        c.row_factory = sqlite3.Row
        return c
    
    def _init_schema(self):
        schema = """
        CREATE TABLE IF NOT EXISTS books (
        id INTEGER PRIMARY KEY,
        title TEXT NOT NULL,
        author TEXT,
        genre TEXT,
        year_published INTEGER, 
        availability BOOLEAN
        )
        """
        with self._conn() as c:
            c.executescript(schema)
    
    def metadata_query(self, ids):
        with self._conn() as conn:
            placeholders = ', '.join(['?']*len(ids))
            query = f"SELECT * FROM books WHERE id IN  ({placeholders})"
            cur = conn.cursor()
            cur.execute(query, ids)
            rows = cur.fetchall()
            return rows
    
    def homepage_query(self):
        with self._conn() as conn:
            query = "SELECT * FROM books ORDER BY title ASC LIMIT 50"
            cur = conn.cursor()
            cur.execute(query)
            rows = cur.fetchall()
            return rows



def handle(op, payload):
    if op == "query":
        query_vec = model.encode(payload)
        D,I = index.search(query_vec.reshape(1, -1).astype('float32'), 50)
        rows = db.metadata_query(I[0].tolist())
        return [dict(row) for row in rows]
    elif op == "homepage_display":
        rows = db.homepage_query()
        return [dict(row) for row in rows]



def main():
    flag = {"flag": "model is loaded"}
    sys.stdout.write(json.dumps(flag) + "\n")
    for raw in sys.stdin:
        line = raw.strip()
        msg = json.loads(line)
        req_id = msg.get("req_id")
        op = msg.get("op")
        payload  = msg.get("payload", {})
        result = handle(op, payload)
        out = {"req_id": req_id, "result:": result}
        sys.stdout.write(json.dumps(out) + "\n")
        sys.stdout.flush()

if __name__ == "__main__":
    model = SentenceTransformer("sentence-transformers/all-MiniLM-L6-v2")
    index = faiss.read_index("book_embeddings.faiss")
    db = DB()
    main()