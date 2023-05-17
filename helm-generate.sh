#!/bin/bash

rm *.tgz
helm package pgbouncer
helm repo index --url https://bitgin.github.io/helm --merge index.yaml .
