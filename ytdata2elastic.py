import pandas as pd
import numpy as np 

from elastic_api.es_doc_indexer import ESDocIndexer 

youtube_data_file = 'data/youtube.csv'

def get_rows():
    data = pd.read_csv(youtube_data_file, encoding='utf-8')
    for _, row in data.iterrows():
        result = {'source_type': 'youtube'}
        if row['hasReplies'] is not np.nan:
            result['reply_to'] = None 
            result['user_name'] = row['user']
            result['internal_user_id'] = row['user']
            result['comment'] = row['commentText']
            result['timestamp'] = int(row['timestamp'])
            result['source'] = ''
            result['likes'] = int(row['likes'])
            result['number_of_replies'] = row['numberOfReplies']
        else:
            prefix = 'default-'
            if row['replies.id'].startswith(prefix):
                reply_to_id = row['replies.id'][len(prefix):].partition('.')[0]
            else:
                reply_to_id = row['replies.id'].partition('.')[0]

            result['reply_to'] = list(data[data.id == reply_to_id].user)[0]

            result['user_name'] = row['replies.user']
            result['internal_user_id'] = row['replies.user']
            result['comment'] = row['replies.commentText']
            result['timestamp'] = int(row['replies.timestamp'])
            result['source'] = ''
            result['likes'] = int(row['replies.likes'])
            result['number_of_replies'] = 0


        yield(result)

if __name__ == '__main__':
    indexer = ESDocIndexer({"es_address": '192.168.1.144:9200'})
    for row in get_rows():
        indexer.insert_document(row)
