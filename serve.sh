#!/usr/bin/env bash

# simple file that can be run in IntelliJ to serve the docs directly in the IDE
pipenv run mkdocs serve --dev-addr=127.0.0.1:9000
