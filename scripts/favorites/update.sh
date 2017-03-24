#!/bin/bash

API="${API_ORIGIN:-http://localhost:4741}"
URL_PATH="/favorites/${ID}"
curl "${API}${URL_PATH}" \
  --include \
  --request PATCH \
  --header "Content-Type: application/json" \
  --header "Authorization: Token token=$TOKEN" \
  --data '{
    "favorite": {
      "picture_id": "'"${PICTURE_ID}"'"
    }
  }'
echo
