from unittest import TestCase

from elastic_api.es_doc_indexer import ESDocIndexer
import pprint


class TestESDocIndexer(TestCase):
    """
    WARN: This test requires running ES on localhost
    WARN: This test can DAMAGE data
    """

    def setUp(self):
        self.elastic = ESDocIndexer({
            ESDocIndexer.CONFIG_ES_ADDRESS: "192.168.1.144:9200"
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
            index=self.elastic.index_name,
            doc_type=self.elastic.mapping_name,
            body={
                "query": {
                    "match": {
                        "comment": "Putin"
                    }
                }
            }
        )

    def test_search_fields(self):
        putin_search = self.elastic.search_by_fields({
            "comment": "Putin"
        })

        likes_search = self.elastic.search_query({
            "query": {
                "range": {
                    "likes": {
                        "lte": 0
                    }
                }
            }
        })

        bool_search = self.elastic.search_query({
            "query": {
                "bool": {
                    "must": {
                        "match": {
                            "source_type": "twitter"
                        }
                    },
                    "should": {
                        "match": {
                            "comment": "Путин"
                        }
                    }
                }
            }
        })

        print("---")
        pprint.pprint(self.elastic.get_hits(putin_search))
        print("---")
        pprint.pprint(self.elastic.get_hits(likes_search))
        print("---")
        pprint.pprint(self.elastic.get_hits(bool_search))

    def update_test(self):

        putin_search = self.elastic.search_by_fields({
            "comment": "Putin"
        })

        record_id = self.elastic.get_hits(putin_search)[0]["_id"]

        self.elastic.update_record(record_id, {
            "sentiment": 100
        })

    def test_drop_index(self):
        self.elastic.delete_index()
