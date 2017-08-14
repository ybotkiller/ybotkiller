from comment_bucket import CommentBucket
import csv
import json
from user import User
import re


class Aggregator(object):
    def __init__(self, service, video_id):
        self.service = service
        self.video_id = video_id
        self.data = []
        self.fieldnames = ["id", "author", "time", "timestamp", "text",
            "likes", "hasReplies", "numReplies", "authorLink",
            "subscriberCount", "viewCount", "hiddenSubscriberCount",
            "commentCount", "videoCount"]

    def aggregate(self):
        cb = CommentBucket(self.video_id)
        cb.fetch_all_comments()
        for comment in cb.comments:
            ui = User(self.service, comment["author"],
                re.sub("^.*\/", "", comment["authorLink"]))
            self.data.append(dict(comment.items() +
                ui.get_basic_user_info().items()))

    def get_json(self):
        with open("{}.json".format(self.video_id), "w") as json_file:
            json.dump(self.data, json_file,
                indent=4, sort_keys=True, separators=(',', ':'))

    def get_csv(self):
        with open("{}.csv".format(self.video_id), "w") as csv_file:
            writer = csv.DictWriter(csv_file,
                fieldnames=self.fieldnames)

            writer.writeheader()
            for el in self.data:
                writer.writerow(dict((s[0],
                    unicode(s[1]).encode("utf-8")) for s in el.iteritems()))
