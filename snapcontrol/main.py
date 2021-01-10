from flask import Flask, render_template, request
from zero import snapserver;
from zero import mopidy;
from snapclient import snapclient;
import json

app = Flask(__name__)

@app.route('/')
def index():
   return render_template("index.html")

@app.route('/snapservers')
def snapserver_list():
   return json.dumps(snapserver.get_list())

@app.route('/mopidies')
def mopidy_list():
   return json.dumps(mopidy.get_list())

@app.route('/client/connect')
def client_connect():
    client = None
    server = None
    if "client" in request.args:
        client = request.args["client"]
    if "server" in request.args:
        server = request.args["server"]
    return snapclient.connect(client=client,server=server)

if __name__ == '__main__':
   app.run(host= '0.0.0.0')
