#!/bin/bash
docker build -t devops-challenge-1-flask .
docker run -p 5000:5000 --rm devops-challenge-1-flask
