from elastic_api.es_doc_indexer import ESDocIndexer
import csv

csvfile = open("data/twitter_confirmed_1.csv", "w", newline='')

cvswriter = csv.writer(csvfile, delimiter=',',
                       quotechar='"', quoting=csv.QUOTE_MINIMAL)


def saver(id, row):
    values = [
        row.get("internal_user_id") or "",
        row.get("user_name") or "",
        row.get("comment") or "",
        row.get("reply_to") or "",
        row.get("timestamp") or "",
        row.get("source_type") or "",
        row.get("source") or "",
        row.get("user_real_name") or "",
        row.get("time_zone") or "",
        row.get("verified") or "",
        row.get("friends") or "",
        row.get("followers") or "",
        row.get("user_created_at") or "",
        row.get("favourites") or "",
        row.get("extended profile") or "",
        row.get("confirmed") or "",
        row.get("polyglot_sentiment") or "",
        row.get("polyglot_sentiment_num") or ""
    ]
    cvswriter.writerow(values)


elastic = ESDocIndexer()

elastic.scroll_full_base(
    callback=saver,
    query={
        "query": {
            "bool": {
                "must": [
                    {
                        "match": {
                            "source_type": "twitter"
                        }
                    }
                    , {
                        "match": {
                            "confirmed": 1
                        }
                    }
                ]
            }
        }
    }
)
