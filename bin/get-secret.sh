#!/usr/bin/env bash

name=$1
kubectl get secret "$name" --namespace tlab-dea-prod -o yaml
