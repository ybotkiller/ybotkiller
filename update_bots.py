import pickle

from elastic_api.es_doc_indexer import ESDocIndexer

model = pickle.load(open("./notebooks/model_hypercomments3.pkl", 'rb'))


def sentiment_updater(record):
    # res = analyser.get_sentiment(record['comment']) // 2

    not_bot_prob, bot_prob = model.predict_proba([record['comment']])[0]
    return {
        "not_bot_prob": not_bot_prob,
        "bot_prob": bot_prob
    }


elastic = ESDocIndexer()

elastic.full_base_updater(
    callback=sentiment_updater
)
