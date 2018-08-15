import os, sys
sys.path.append(os.path.join(os.path.dirname(__file__), '..'))
from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello():
    return 'Hello, ' + (os.environ['HELLO'] if 'HELLO' in os.environ else 'world') + '!'

@app.route('/howdy')
def howdy():
    return 'Howdy, ' + (os.environ['HOWDY'] if 'HOWDY' in os.environ else 'texas') + '!'

if __name__ == "__main__":
    app.run(
        host='0.0.0.0'
    )
