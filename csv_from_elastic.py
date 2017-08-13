from elastic_api.es_doc_indexer import ESDocIndexer
import csv

csvfile = open("data/elastic_export.tsv", "w", newline='')

cvswriter = csv.writer(csvfile, delimiter=',',
                       quotechar='"', quoting=csv.QUOTE_MINIMAL)


def saver(id, row):

    values = [
        row['user_name'],
        row['comment'],
        row['timestamp'],
        row['reply_to'],
        row.get('polyglot_sentiment_num') or 0
    ]
    cvswriter.writerow(values)

elastic = ESDocIndexer()

elastic.scroll_full_base(
    callback=saver,
    query={
        "query": {
            "match": {
                "confirmed": 1
            }
        }
    }
)
