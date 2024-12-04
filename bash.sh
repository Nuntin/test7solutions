#!/bin/bash
docker login
docker build -t test .
docker tag test yourusername/test:latest
docker push yourusername/test:latest