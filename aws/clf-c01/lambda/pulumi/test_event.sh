#!/bin/bash

aws lambda invoke \
--function-name $(pulumi stack output lambda) \
--region $(pulumi config get aws:region) \
--payload '{ "first_name": "Egor", "last_name": "Alekseev" }' \
output.json

cat output.json 