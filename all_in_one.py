from sentence_transformers import SentenceTransformer
import numpy as np
import sys, json
import faiss

# class Embedder:
#     def __init__(self):
#         self.model = SentenceTransformer("sentence-transformers/all-MiniLM-L6-v2")
    
#     def embed_one(query):
#         return model.encode(query)
    

def handle(op, payload):
    if op == "query":
        query_vec = model.encode(payload)
        D,I = index.search(query_vec.reshape(1, -1).astype('float32'), 5)
        return {"top 5 matches": I[0].tolist()}


def main():
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
    main()