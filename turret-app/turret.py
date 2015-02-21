#!/usr/bin/python
from flask import Flask, request
app = Flask(__name__)

@app.route('/')
def base():
  return 'Are you still there?\n'

@app.route('/target')
def target():
  return str(request.remote_addr)

if __name__ == '__main__':
  app.run(host='0.0.0.0',port=8080)
