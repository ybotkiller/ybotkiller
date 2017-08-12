from polyglot.text import Text


class SentimentAnalyser:
    def __init__(self):
        pass

    def get_sentiment(self, text):
        text = Text(text, hint_language_code='ru')
        sentiment = 0
        for word in text.words:
            sentiment += word.polarity

        return int(sentiment)
