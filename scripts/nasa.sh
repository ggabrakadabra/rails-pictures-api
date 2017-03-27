#!/bin/bash

API="${API_ORIGIN:-http://localhost:4741}"
URL_PATH="/examples"
TOKEN="BAhJIiUyYTFlMTkwZmQ0YTk4NDg2NTZiZjA5ODBiYWY2MDAyMAY6BkVG--e19895e69907eaef9b5a4ef0fbc6b15cb52f75d6"
curl "${API}${URL_PATH}" \
  --include \
  --request POST \
  --header "Content-Type: application/json" \
   --header "Authorization: Token token=$TOKEN" \
  --data '{
    "search": {
      "query": "'"${QUERY}"'"
    }
  }'

echo
