from unittest import TestCase

import polyglot.text as ptx

from sentiment.sentiment import SentimentAnalyser


class TestSentimentAnalyser(TestCase):
    def setUp(self):
        self.analyser = SentimentAnalyser()

    def test_get_sentiment(self):
        bad = "Навальный предатель родины! Я ненавижу всех либерастов!"
        good = "Я люблю Путина! Он самый лучший президент в мире, а буду за него молиться!"

        bad_estimate = self.analyser.get_sentiment(bad)
        good_estimate = self.analyser.get_sentiment(good)

        print(bad_estimate)
        print(good_estimate)

        self.assertTrue(bad_estimate < 0)
        self.assertTrue(good_estimate > 0)
