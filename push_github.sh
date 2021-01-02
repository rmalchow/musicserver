#!/bin/bash

git add .
git commit -m "ensure pushed"
git pull github master
git merge github master
git push github --force
