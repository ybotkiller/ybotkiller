from unittest import TestCase

from sentiment.dict_sentiment import DictSentiment


class TestDictSentiment(TestCase):
    def setUp(self):
        self.analyser = DictSentiment()

    def test_check(self):

        wtf = "Сборище даунов бля и придурков " \
              " Все ваши потуги не имеют никакого смысла, кроме развода тех же даунов и придурков " \
              " Уголовников не регистрируют!"

        wtf_estimate = self.analyser.get_sentiment(wtf)
        print(wtf_estimate)
        self.assertTrue(wtf_estimate < 0)

