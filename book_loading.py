from sentence_transformers import SentenceTransformer
import faiss
import numpy as np
from sklearn.preprocessing import normalize
import sys
import sqlite3
# titles = ["Journeys Beyond the Horizon",
#           "The Edge of the Map",
#           "Explorers of the Unknown",
#           "Into the Farthest Lands",
#           "The Path of Discovery",
#           "The Depths of Thought",
#           "Horizons of the Mind",
#           "The Nature of Knowing",
#           "Reflections on Reality",
#           "The Infinite Within"]
# model = SentenceTransformer("sentence-transformers/all-MiniLM-L6-v2")
# embs = model.encode(titles, batch_size=64, convert_to_numpy=True)
# embs = normalize(embs)

# d = 384

# index = faiss.IndexIDMap(faiss.IndexFlatIP(d))
# start_id = index.ntotal
# num_new = embs.shape[0]
# ids = np.arange(start_id, start_id + num_new)
# index.add_with_ids(embs, ids)
# faiss.write_index(index, "book_embeddings.faiss")

def _conn():
    c = sqlite3.connect("books.db")
    c.row_factory = sqlite3.Row
    return c

with _conn() as c:
    query = """
    INSERT INTO books (id, title, author, genre, year_published)
    VALUES
    (0, 'Journeys Beyond the Horizon', 'Amelia Cross', 'Travel Memoir', 2012),
    (1, 'The Edge of the Map', 'Julian Rivers', 'Adventure', 2015),
    (2, 'Explorers of the Unknown', 'Nathaniel Burke', 'Historical Nonfiction', 2009),
    (3, 'Into the Farthest Lands', 'Clara Westwood', 'Adventure Fiction', 2017),
    (4, 'The Path of Discovery', 'Eleanor Graves', 'Philosophy', 2011),
    (5, 'The Depths of Thought', 'Marcus Vane', 'Philosophy', 2003),
    (6, 'Horizons of the Mind', 'Lydia Chen', 'Psychology', 2018),
    (7, 'The Nature of Knowing', 'Dr. Samuel Ortiz', 'Cognitive Science', 2020),
    (8, 'Reflections on Reality', 'Isabelle Laurent', 'Metaphysics', 2014),
    (9, 'The Infinite Within', 'Thomas Calder', 'Spirituality', 2019)
    """
    c.executescript(query)
