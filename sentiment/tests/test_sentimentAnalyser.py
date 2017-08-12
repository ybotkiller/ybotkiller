from unittest import TestCase

import polyglot.text as ptx

from sentiment.sentiment import SentimentAnalyser


class TestSentimentAnalyser(TestCase):
    def setUp(self):
        self.analyser = SentimentAnalyser()

    def test_get_sentiment(self):
        bad = "Навальный предатель родины! Я ненавижу всех либерастов!"
        good = "Я люблю Путина! Он самый лучший президент в мире, а буду за него молиться!"

        wtf = "Сборище даунов и придурков " \
              "все ваши потуги не имеют никакого смысла, кроме развода тех же даунов и придурков " \
              "уголовников не регистрируют!"

        bad_estimate = self.analyser.get_sentiment(bad)
        good_estimate = self.analyser.get_sentiment(good)
        wtf_estimate = self.analyser.get_sentiment(wtf)

        print(bad_estimate)
        print(good_estimate)
        print(wtf_estimate)

        self.assertTrue(bad_estimate < 0)
        self.assertTrue(good_estimate > 0)
