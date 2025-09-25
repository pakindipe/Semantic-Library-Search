from sentence_transformers import SentenceTransformer
import numpy as np


model = SentenceTransformer("sentence-transformers/all-MiniLM-L6-v2")
vec1 = model.encode("hello this is Dave!", convert_to_numpy=True).astype("float32")
vec2 = model.encode("hello I am Dave", convert_to_numpy=True).astype("float32")
vec3 = model.encode("Fundamentals of programming", convert_to_numpy=True).astype("float32")

def normalize(vec):
    return vec / (np.linalg.norm(vec) + 1e-12)

vec1 = normalize(vec1)
vec2 = normalize(vec2)
vec3 = normalize(vec3)

if ((vec1 @ vec2) > (vec1 @ vec3)):
    print("first two sentences are more alike!")
    print((vec1 @ vec2) - (vec1 @ vec3))
else:
    print("first and third are more alike!")
