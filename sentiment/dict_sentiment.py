from collections import defaultdict

from polyglot.text import Text, Word

import os


class DictSentiment:
    def __init__(self):
        self.obs_dict = defaultdict(int)
        dir = os.path.dirname(__file__)
        fname = os.path.join(dir, "obscene_corpus.txt")
        with open(fname, "r") as fd:
            for line in fd:
                line = line.strip().upper()
                self.obs_dict[line] = -1

    def get_sentiment(self, text):
        text = Text(text, hint_language_code='ru')
        return sum(map(self.check_word, text.words))

    def check_word(self, word: Word):
        return self.obs_dict[word.string.upper()]
