#!/bin/bash

API="${API_ORIGIN:-http://localhost:4741}"
URL_PATH="/comments/${ID}"
TOKEN="BAhJIiUyODI4NWVlNmMxMmY3ZWM1YjlkMTdhOGFlMjA4M2NjZgY6BkVG--2ed74d61dabe52140aecec2107c1e83b83ba3b41"
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
