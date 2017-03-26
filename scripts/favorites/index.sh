API="${API_ORIGIN:-http://localhost:4741}"
URL_PATH="/favorites"
TOKEN="BAhJIiUyODI4NWVlNmMxMmY3ZWM1YjlkMTdhOGFlMjA4M2NjZgY6BkVG--2ed74d61dabe52140aecec2107c1e83b83ba3b41"
curl "${API}${URL_PATH}" \
 --include \
 --request GET \
 --header "Authorization: Token token=$TOKEN"

echo
