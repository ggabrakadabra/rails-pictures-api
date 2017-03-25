#!/bin/bash

API="${API_ORIGIN:-http://localhost:4741}"
URL_PATH="/comments/${ID}"
TOKEN="BAhJIiViY2E3OThhYjczMDk2ODNiM2ZiMWRlZGNhNjcxYjQyNwY6BkVG--28c4215497d4c3103dca2c2fb034051b681f16d7"
curl "${API}${URL_PATH}" \
  --include \
  --request PATCH \
  --header "Content-Type: application/json" \
  --header "Authorization: Token token=$TOKEN" \
  --data '{
    "comment": {
      "picture_id": "'"${PICTURE_ID}"'",
      "note": "'"${NOTE}"'"
    }
  }'
echo
