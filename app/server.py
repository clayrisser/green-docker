from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello():
    return 'Hello, ' + os.environ['HELLO'] + '!'

@app.route('/howdy')
def howdy():
    return 'Howdy, ' + os.environ['HOWDY'] + '!'

if __name__ == "__main__":
    app.run()
