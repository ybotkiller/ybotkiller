# -*- coding: utf-8
import csv
import os
import re
import json
import subprocess


class CommentBucket(object):
    def __init__(self, video_id):
        self.video_id = video_id
        self.comments = {}
        self.fieldnames = ["id", "author", "time", "timestamp", "text",
            "likes", "hasReplies", "numReplies"]

    def _better_json(self):
        better_lines = []

        with open("fetched.json") as fetched:
            lines = fetched.readlines()
            for line in lines:
                try:
                    if not "replies:" in line:
                        l1 = re.search("[^\s]+:", line).group(0)[:-1]
                        l0 = re.search("^.*{}:".format(l1), line).group(0)
                        l0 = re.sub(l1 + ":", "", l0)
                        l1 = "\"{}\"".format(l1)
                        l2 = re.search(": .*,$", line).group(0)[2:]
                        l3 = re.search("[\s},]+$", line).group(0)
                        l2 = re.sub(l3, "", l2)
                        l2 = re.sub("(^'|'$)", "", l2)
                        l2 = re.sub("\"", "\\\"", l2)
                        l2 = ": \"{}\"".format(l2)
                        better_lines.append(l0 + l1 + l2 + l3)
                except Exception as ex:
                    pass

        with open("fetched.json", "w") as fetched:
            for el in better_lines:
                fetched.write(el)

    def fetch_all_comments(self):
        subprocess.call("node fetch-all-comments.js {} > fetched.json".format(self.video_id),
            shell=True)
        self._better_json()
        with open("fetched.json") as fetched:
            self.comments = json.load(fetched)
        os.remove("fetched.json")

        diff = set(self.comments) - set(self.fieldnames)
        for el in diff:
            del self.comments[el]

        for data in self.comments:
            for el in data.iteritems():
                data[el[0]] = re.sub(u"[^a-zA-Zа-яА-Я\s\d,.:?!()<>\"'-_;^*]+",
                    "", unicode(el[1], "utf8"))

    def get_json(self):
        with open("{}.json".format(self.video_id), "w") as json_file:
            json.dump(self.comments, json_file,
                indent=4, sort_keys=True, separators=(',', ':'))

    def get_csv(self):
        with open("{}.csv".format(self.video_id), "w") as csv_file:
            writer = csv.DictWriter(csvfile, fieldnames=fieldnames)

            writer.writeheader()
            for el in self.comments:
                writer.writerow(dict((s[0],
                    unicode(s[1]).encode("utf-8")) for s in el.iteritems()))
