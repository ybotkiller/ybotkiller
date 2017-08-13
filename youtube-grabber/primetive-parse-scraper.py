# -*- coding: utf-8
import csv
import re
import codecs


class RePackage(object):
    re_left = re.compile(u"[^a-zA-Zа-яА-Я\s\d,.:?!()<>\"'-_;^*]+")

input_f = "comments.csv"
data_lst = list()
fieldnames = ["id", "user", "date", "timestamp", "commentText", "likes",
    "hasReplies", "numberOfReplies"]

def parse():
    with open(input_f) as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            data = dict()
            for el in row.iteritems():
                if el[0] in fieldnames:
                    data[el[0]] = re.sub(RePackage.re_left, "",
                        unicode(el[1], "utf8"))
            data_lst.append(data)

def write():
    with open("result.csv", "w") as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)

        writer.writeheader()
        for el in data_lst:
            writer.writerow(dict((s[0],
                unicode(s[1]).encode("utf-8")) for s in el.iteritems()))

parse()
write()
