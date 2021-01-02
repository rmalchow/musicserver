#!/bin/bash

git add .
git commit -m "ensure pushed"
git pull github
git merge github main
git push github --force
