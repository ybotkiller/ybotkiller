from sklearn.externals import joblib

from flask import Flask, render_template, request

app = Flask(__name__)

model = joblib.load('model_hypercomments2.pkl')


@app.route('/', methods=['GET', 'POST'])
def index():

    comment = None
    try:
        comment = request.form['comment']
    except Exception as e:
        print e

    result = {}
    if comment:
        result['comment'] = comment
        result['score'] = model.predict_proba([comment])[0][1]

    return render_template('index.html', **result)


if __name__ == '__main__':
    app.run(host='0.0.0.0')
