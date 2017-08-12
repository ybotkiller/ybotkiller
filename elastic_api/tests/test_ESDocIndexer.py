from unittest import TestCase

from elastic_api.es_doc_indexer import ESDocIndexer


class TestESDocIndexer(TestCase):
    """
    WARN: This test requires running ES on localhost
    WARN: This test can DAMAGE data
    """

    def test_insert_document(self):
        elastic = ESDocIndexer()

        index_exists = elastic.check_index_exists()
        if not index_exists:
            elastic.create_index()

        elastic.insert_document({
            'internal_user_id': "1723681",
            'user_name': "Kremle60t",
            'comment': "Я ненавижу всё новое и люблю Путина!",
            'reply_to': None,
            'timestamp': 1502537659000,
            'source_type': "twitter",
            'source': "twitter.com/tweets/12345",
            'custom_field': 123,
            'custom_field2': "text here"
        })

        elastic.insert_document({
            'internal_user_id': "12312",
            'user_name': "MrGoodMan",
            'comment': "Navalny is cool, Putin is a thief",
            'reply_to': None,
            'timestamp': 1502527659000,
            'source_type': "twitter",
            'source': "twitter.com/tweets/12346",
            'custom_field': 1881,
            'custom_field2': "text here"
        })

    def test_drop_index(self):
        elastic = ESDocIndexer()
        elastic.delete_index()
