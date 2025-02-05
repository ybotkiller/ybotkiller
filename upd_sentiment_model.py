import pickle

from elastic_api.es_doc_indexer import ESDocIndexer

model = pickle.load(open("data/sentiment_model.pickle", 'rb'))


def sentiment_updater(record):
    # res = analyser.get_sentiment(record['comment']) // 2

    neg, pos = model.predict_proba([record['comment']])[0]
    return {
        "model_sentiment_pos": pos,
        "model_sentiment_neg": neg
    }


elastic = ESDocIndexer()

elastic.full_base_updater(
    callback=sentiment_updater
)
