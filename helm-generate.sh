#!/bin/bash

rm *.tgz index.yaml
helm package pgbouncer
helm repo index --url https://bitgin.github.io/helm --merge index.yaml .
