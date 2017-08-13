# -*- coding: utf-8
import csv
import re
import codecs


class RePackage(object):
    re_left = re.compile(u"[^a-zA-Zа-яА-Я\s\d,.:?!()<>\"'-_;^*]+")

input_f = "twitter_no_confirmed.csv"
output_f = "twitter_no_confirmed_result.csv"
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
    with open(output_f, "w") as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)

        writer.writeheader()
        for el in data_lst:
            writer.writerow(dict((s[0],
                unicode(s[1]).encode("utf-8")) for s in el.iteritems()))

csv_data = []

def parse_csv():
    with open(input_f) as csvfile:
        spamreader = csv.reader(csvfile)
        for row in spamreader:
            tmp = []
            for el in row:
                tmp.append(re.sub(RePackage.re_left, "",
                    unicode(el, "utf8")))
            csv_data.append(tmp)

def write_csv():
    with open(output_f, "w") as csvfile:
        spamwriter = csv.writer(csvfile)
        for row in csv_data:
            spamwriter.writerow([unicode(el).encode("utf-8") for el in row])

parse_csv()
write_csv()
