from flask import Flask

app = Flask(__name__)

@app.route("/")
def home():
    return "Movie Review API v1.0.0"

if __name__ == '__main__':
    app.run(debug=True)