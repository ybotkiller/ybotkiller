from sklearn.linear_model import LogisticRegression, LinearRegression, Lasso, LogisticRegressionCV
from sklearn.feature_extraction.text import CountVectorizer, TfidfVectorizer
from sklearn.pipeline import Pipeline, FeatureUnion
from sklearn.decomposition import PCA, TruncatedSVD

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
