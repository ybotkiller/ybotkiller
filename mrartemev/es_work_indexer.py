import datetime
from es_doc_indexer import ESDocIndexer
import pickle
epoch = datetime.datetime.utcfromtimestamp(0)
def unix_time_millis(dt):
    return int((dt - epoch).total_seconds() * 1000.0)


class DocumentInserter():
    def setUp(self):
        self.elastic = ESDocIndexer({
            ESDocIndexer.CONFIG_ES_ADDRESS: "192.168.1.144:9200"
        })

    def insert_document(self, status):
        index_exists = self.elastic.check_index_exists()
        if not index_exists:
            self.elastic.create_index()
        ans_to = 'not'
        try:
            ans_to = status.entities['user_mentions'][0]['screen_name']
        except Exception:
            ans_to = 'noone'

        try:
            self.elastic.insert_document({
                'internal_user_id': status.user.id,
                'user_name': status.user.screen_name,
                'comment': status.text,
                'reply_to': ans_to,
                'timestamp': unix_time_millis(status.created_at),
                'source_type': "twitter",
                'source': "ToDo",
                'user_real_name': status.author.name,
                'time_zone': status.author.time_zone,
                'verified': status.author.verified,
                'friends': status.author.friends_count,
                'followers': status.author.followers_count,
                'user_created_at': unix_time_millis(status.author.created_at),
                'favourites': status.author.favourites_count,
                'extended profile': status.author.has_extended_profile,
                'confirmed': 1
            })
        except Exception as e:
            print('exception lul')
doc = DocumentInserter()
doc.setUp()
statuses = []
with open('./confirmed.pickle', 'rb') as f:
    statuses = pickle.load(f)

for status in statuses:
    doc.insert_document(status)
    print(status.text, end=' Added \n')

