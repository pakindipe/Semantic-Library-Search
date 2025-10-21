import tensorflow as tf
import tensorflow_hub as hub

ENCODER_URL = "https://tfhub.dev/google/universal-sentence-encoder/4"

embed_layer = hub.KerasLayer(ENCODER_URL, trainable=False)

class StringEmbedder(tf.Module):
    def __init__(self, encoder):
        super().__init__()
        self.encoder = encoder

    @tf.function(input_signature=[tf.TensorSpec(shape=[None], dtype=tf.string, name="text")])
    def embed(self, text):
        vecs = self.encoder(text)
        normed = tf.math.l2_normalize(vecs, axis=1)
        return {"embedding": normed}
    

def export(export_dir="export/string_embedder/1"):
    module = StringEmbedder(embed_layer)
    tf.saved_model.save(
        module,
        export_dir,
        signatures={"serving_default": module.embed}
    )

if __name__ == "__main__":
    export()