from polyglot.text import Text


class SentimentAnalyser:
    def __init__(self):
        pass

    def get_sentiment(self, text):

        text = Text(text)
        sentiment = 0
        for word in text.words:
            sentiment += word.polarity

        return sentiment
