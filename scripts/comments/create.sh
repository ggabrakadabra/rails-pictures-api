API="${API_ORIGIN:-http://localhost:4741}"
URL_PATH="/comments"
TOKEN="BAhJIiU3ODk2ZDVhMDIyMjliNWY4NzAxMzY3NzgwODJhY2Y2YgY6BkVG--412738c66de6b950da70af85a447b34cafcb6852"
curl "${API}${URL_PATH}" \
 --include \
 --request POST \
 --header "Content-Type: application/json" \
 --header "Authorization: Token token=$TOKEN" \
 --data '{
   "comment": {
     "picture_id": "'"${PICTURE_ID}"'",
     "note": "'"${NOTE}"'"
   }
 }'

 echo
