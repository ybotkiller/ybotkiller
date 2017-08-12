from unittest import TestCase

from elastic_api.es_doc_indexer import ESDocIndexer


class TestESDocIndexer(TestCase):
    """
    WARN: This test requires running ES on localhost
    WARN: This test can DAMAGE data
    """

    def setUp(self):
        self.elastic = ESDocIndexer({
            ESDocIndexer.CONFIG_ES_ADDRESS: "172.17.0.1:9200"
        })

    def test_insert_document(self):
        index_exists = self.elastic.check_index_exists()
        if not index_exists:
            self.elastic.create_index()

        self.elastic.insert_document({
            'internal_user_id': "1723681",
            'user_name': "Kremle60t",
            'comment': "Я ненавижу всё новое и люблю Путина!",
            'reply_to': None,
            'timestamp': 1502537659000,
            'source_type': "twitter",
            'source': "twitter.com/tweets/12345",
            'likes': -1000,
            'custom_field': 123,
            'custom_field2': "text here"
        })

        self.elastic.insert_document({
            'internal_user_id': "12312",
            'user_name': "MrGoodMan",
            'comment': "Navalny is cool, Putin is a thief",
            'reply_to': None,
            'timestamp': 1502527659000,
            'source_type': "twitter",
            'source': "twitter.com/tweets/12346",
            'likes': 1000,
            'custom_field': 1881,
            'custom_field2': "text here"
        })

    def test_delete_by_query(self):

        self.elastic.es.delete_by_query(
            self.elastic.index_name,
            {
                "query": {
                    ""
                }
            }
        )

    def test_drop_index(self):
        self.elastic.delete_index()
