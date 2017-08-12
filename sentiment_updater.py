from elastic_api.es_doc_indexer import ESDocIndexer
from sentiment.sentiment import SentimentAnalyser

analyser = SentimentAnalyser()


def sentiment_updater(record):
    res = analyser.get_sentiment(record['comment'])
    category = "neutral"
    if res < 0:
        category = "evil"
    if res > 0:
        category = "good"
    return {
        "polyglot_sentiment": category,
        "polyglot_sentiment_num": res
    }


elastic = ESDocIndexer()

elastic.full_base_updater(
    callback=sentiment_updater
)
