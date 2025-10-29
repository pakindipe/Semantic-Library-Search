from sentence_transformers import SentenceTransformer
import numpy as np
import sys, json

model = SentenceTransformer("sentence-transformers/all-MiniLM-L6-v2")

def handle(op, payload):
    if op == "embed_one":
        emb = model.encode(payload)
        vec_list = emb.tolist()
        return {"vector": vec_list}


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
    main()
