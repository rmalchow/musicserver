#!/bin/bash




cd $(dirname ${0})

if [ -f bin/active ]; then
  echo "apparently, dependencies are already installed"
  . ./bin/activate
else
  echo "installing dependencies"
  python3 -m venv /music/snapcontrol
  . ./bin/activate
  pip3 install zeroconf flask flask-jsonpify flask-sqlalchemy flask-restful uwsgi requests psutil
fi

exec nohup python3 main.py
