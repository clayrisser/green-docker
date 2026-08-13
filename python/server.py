import os

from flask import Flask, jsonify

app = Flask(__name__)


@app.route("/")
def hello():
    return jsonify(hello=os.environ.get("HELLO", "world"))


@app.route("/howdy")
def howdy():
    return jsonify(howdy=os.environ.get("HOWDY", "texas"))


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int(os.environ.get("PORT", "5000")))
