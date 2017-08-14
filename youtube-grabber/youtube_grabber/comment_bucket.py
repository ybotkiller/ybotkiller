# -*- coding: utf-8
import csv
import os
import re
import json
import subprocess


class CommentBucket(object):
    def __init__(self, video_id):
        self.video_id = video_id
        self.comments = []
        self.fieldnames = ["id", "author", "time", "timestamp", "text",
            "likes", "hasReplies", "numReplies", "authorLink"]

    def _format(self, comments, filtered_comments):
        for comment in comments:
            filtered_comments.append(
                {k: comment[k] for k in self.fieldnames if k in comment})
            if "replies" in comment:
                self._format(comment["replies"], filtered_comments)

    def _clear(self):
        for comment in self.comments:
            for el in comment.iteritems():
                try:
                    comment[el[0]] = re.sub(
                        u"[^a-zA-Zа-яА-Я\s\d,.:?!()<>\"'-_;^*]+",
                        "", el[1])
                except:
                    pass

    def fetch_all_comments(self):
        subprocess.call("node fetch-all-comments.js {} > fetched.json".
            format(self.video_id),
            shell=True)
        with open("fetched.json") as fetched:
            self.comments = json.load(fetched)
        os.remove("fetched.json")

        filtered_comments = []
        self._format(self.comments, filtered_comments)
        self.comments = filtered_comments
        self._clear()

        return self.comments

    def get_json(self):
        with open("{}-comments.json".format(self.video_id), "w") as json_file:
            json.dump(self.comments, json_file,
                indent=4, sort_keys=True, separators=(',', ':'))

    def get_csv(self):
        with open("{}-comments.csv".format(self.video_id), "w") as csv_file:
            writer = csv.DictWriter(csv_file, fieldnames=self.fieldnames)

            writer.writeheader()
            for el in self.comments:
                writer.writerow(dict((s[0],
                    unicode(s[1]).encode("utf-8")) for s in el.iteritems()))
