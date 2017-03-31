## Links

**Live site:** <https://ggwilliams.github.io/pictures-app-client/>

**Front End Repo:** <https://github.com/ggwilliams/pictures-app-client>

**Deployed:** <https://salty-ravine-27099.herokuapp.com/>

## ERD
1st ERD:
![ERD1](ERD.jpg "1st ERD")

## Technologies Used
* JavaScript
* jQuery
* Handlebars
* 3rd Party API (NASA)
* Ruby on Rails

## Overview
This Ruby on Rails backend has 3 tables, comments, pictures and favorites. For each of these tables there are corresponding controllers, models, serializers, and scripts to test them. I also have a searches controller that handles all of my api calls. And the routes file displays all of the current routes.

## About
To create an app that would view the NASA Astronomy Picture of the Day website and save the users favorite pictures and also allow users to comment on those pictures, I needed to have 3 tables. A table for pictures that would save the pictures, a table for favorites, and a table for comments.

To begin, I created the table for pictures. I needed scripts to test this feature also.

This is my create pictures script. This script doesn't need a user token because only favorites and comments belong to the user.

```
API="${API_ORIGIN:-http://localhost:4741}"
URL_PATH="/pictures"
TOKEN="BAhJIiViY2E3OThhYjczMDk2ODNiM2ZiMWRlZGNhNjcxYjQyNwY6BkVG--28c4215497d4c3103dca2c2fb034051b681f16d7"
curl "${API}${URL_PATH}" \
 --include \
 --request POST \
 --header "Content-Type: application/json" \
 --header "Authorization: Token token=$TOKEN" \
 --data '{
   "picture": {
     "title": "'"${TITLE}"'"
   }
 }'

 echo
```
Once the pictures table and scripts worked correctly, I added the favorites table. This table authenticates the user since only the user should be able to see and create their own favorites.

This is the script for creating a favorite.
```
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
```

After favorites, I created the users comments on pictures. This would serve as a join table between users and pictures since users have many comments and pictures have many users.

To test that users could create comments, I ran this script.
```
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
```

To make sure that the pictures users were adding were not duplicates I needed to do 2 things.
1) In the pictures controller, I needed to limit the user from creatig duplicate pictures
```
def create
  @picture = current_user.pictures.build(picture_params)

  @existing_pictures = Picture.where(title: @picture.title)
  if @existing_pictures.length > 0
    render json: @existing_pictures[0], status: :created
  elsif @picture.save
    render json: @picture, status: :created
  else
    render json: @picture.errors, status: :unprocessable_entity
  end
end
```
Then, in the favorites controller, I needed to add
```
def create
  @favorite = current_user.favorites.build(favorite_params)

  if Favorite.exists?(user_id: current_user.id,
                      picture_id: favorite_params[:picture_id])
    head :conflict
  elsif @favorite.save
    render json: @favorite, status: :created
  else
    render json: @favorite.errors, status: :unprocessable_entity
  end
end
```

This limits users fro creating duplicate pictures and from adding duplicate favorites.

## Adding the Third Party Api

I was having issues with the NASA third party api in the front end. But having a method that used the NASA api worked better. I had to create a method that would get the data from APOD for todays date and for any date the user searched for.

### NASA API Routes
| Verb   | URI Pattern            | Controller#Action |
|--------|------------------------|-------------------|
| POST   | `/search/sounds`             | `searches#sounds_search`    |
| POST   | `/search/patents`             | `searches#patents_search`    |
| POST  | `/search/mars` | `searches#mars_search`  |
| POST | `/search/apod/today`        | `searches#apod_today`   |
| POST | `/search/apod`        | `searches#apod_search`   |
| POST | `/search/neo/today`        | `searches#neo_today`   |
| POST | `/search/stats`        | `searches#neo_stats`   |

I wanted to make use of as many of the NASA APIs that I could.

```
def apod_search
  query = params[:search][:query]
  api_key = Rails.application.secrets.nasa_api_key
  url = "https://api.nasa.gov/planetary/apod?date=#{query}&api_key=#{api_key}"
  response = open(url)
  data_string = response.read
  json_string = JSON.parse(data_string)
  render json: json_string
end

def apod_today
  api_key = Rails.application.secrets.nasa_api_key
  url = "https://api.nasa.gov/planetary/apod?api_key=#{api_key}"
  response = open(url)
  data_string = response.read
  json_string = JSON.parse(data_string)
  render json: json_string
end
```

These are both methods in the searches controller. I also had to make sure they had separate routes.
```
post '/search/apod/today' => 'searches#apod_today'
post '/search/apod' => 'searches#apod_search'
```
To test that the api calls were working properly, I ran this script.

```
#!/bin/bash

API="${API_ORIGIN:-http://localhost:4741}"
URL_PATH="/search/sounds"
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
```


### Authentication

| Verb   | URI Pattern            | Controller#Action |
|--------|------------------------|-------------------|
| POST   | `/sign-up`             | `users#signup`    |
| POST   | `/sign-in`             | `users#signin`    |
| PATCH  | `/change-password/:id` | `users#changepw`  |
| DELETE | `/sign-out/:id`        | `users#signout`   |

#### POST /sign-up

Request:

```sh
curl http://localhost:4741/sign-up \
  --include \
  --request POST \
  --header "Content-Type: application/json" \
  --data '{
    "credentials": {
      "email": "'"${EMAIL}"'",
      "password": "'"${PASSWORD}"'",
      "password_confirmation": "'"${PASSWORD}"'"
    }
  }'
```

```sh
EMAIL=ava@bob.com PASSWORD=hannah scripts/sign-up.sh
```

Response:

```md
HTTP/1.1 201 Created
Content-Type: application/json; charset=utf-8

{
  "user": {
    "id": 1,
    "email": "ava@bob.com"
  }
}
```

#### POST /sign-in

Request:

```sh
curl http://localhost:4741/sign-in \
  --include \
  --request POST \
  --header "Content-Type: application/json" \
  --data '{
    "credentials": {
      "email": "'"${EMAIL}"'",
      "password": "'"${PASSWORD}"'"
    }
  }'
```

```sh
EMAIL=ava@bob.com PASSWORD=hannah scripts/sign-in.sh
```

Response:

```md
HTTP/1.1 200 OK
Content-Type: application/json; charset=utf-8

{
  "user": {
    "id": 1,
    "email": "ava@bob.com",
    "token": "BAhJIiVlZDIwZTMzMzQzODg5NTBmYjZlNjRlZDZlNzYxYzU2ZAY6BkVG--7e7f77f974edcf5e4887b56918f34cd9fe293b9f"
  }
}
```

#### PATCH /change-password/:id

Request:

```sh
curl --include --request PATCH "http://localhost:4741/change-password/$ID" \
  --header "Authorization: Token token=$TOKEN" \
  --header "Content-Type: application/json" \
  --data '{
    "passwords": {
      "old": "'"${OLDPW}"'",
      "new": "'"${NEWPW}"'"
    }
  }'
```

```sh
ID=1 OLDPW=hannah NEWPW=elle TOKEN=BAhJIiVlZDIwZTMzMzQzODg5NTBmYjZlNjRlZDZlNzYxYzU2ZAY6BkVG--7e7f77f974edcf5e4887b56918f34cd9fe293b9f scripts/change-password.sh
```

Response:

```md
HTTP/1.1 204 No Content
```

#### DELETE /sign-out/:id

Request:

```sh
curl http://localhost:4741/sign-out/$ID \
  --include \
  --request DELETE \
  --header "Authorization: Token token=$TOKEN"
```

```sh
ID=1 TOKEN=BAhJIiVlZDIwZTMzMzQzODg5NTBmYjZlNjRlZDZlNzYxYzU2ZAY6BkVG--7e7f77f974edcf5e4887b56918f34cd9fe293b9f scripts/sign-out.sh
```

Response:

```md
HTTP/1.1 204 No Content
```

### Users

| Verb | URI Pattern | Controller#Action |
|------|-------------|-------------------|
| GET  | `/users`    | `users#index`     |
| GET  | `/users/1`  | `users#show`      |

#### GET /users

Request:

```sh
curl http://localhost:4741/users \
  --include \
  --request GET \
  --header "Authorization: Token token=$TOKEN"
```

```sh
TOKEN=BAhJIiVlZDIwZTMzMzQzODg5NTBmYjZlNjRlZDZlNzYxYzU2ZAY6BkVG--7e7f77f974edcf5e4887b56918f34cd9fe293b9f scripts/users.sh
```

Response:

```md
HTTP/1.1 200 OK
Content-Type: application/json; charset=utf-8

{
  "users": [
    {
      "id": 2,
      "email": "bob@ava.com"
    },
    {
      "id": 1,
      "email": "ava@bob.com"
    }
  ]
}
```

#### GET /users/:id

Request:

```sh
curl --include --request GET http://localhost:4741/users/$ID \
  --header "Authorization: Token token=$TOKEN"
```

```sh
ID=2 TOKEN=BAhJIiVlZDIwZTMzMzQzODg5NTBmYjZlNjRlZDZlNzYxYzU2ZAY6BkVG--7e7f77f974edcf5e4887b56918f34cd9fe293b9f scripts/user.sh
```

Response:

```md
HTTP/1.1 200 OK
Content-Type: application/json; charset=utf-8

{
  "user": {
    "id": 2,
    "email": "bob@ava.com"
  }
}
```

## All Routes
These are all of the routes listed in the back end

| Verb | URI Pattern | Controller#Action |
|------|-------------|-------------------|
| GET  | `/comments`  | `comments#index`      |
| POST |  | `/comments `  |        `comments#create` |
| GET |   |`/comments/:id` |      |  `comments#show` |
| PATCH | | `/comments/:id` |     |   `comments#update` |
| PUT   | | `/comments/:id` |       | `comments#update` |
| DELETE |  |`/comments/:id` |      | `comments#destroy` |
| GET  | |  `/favorites` |          | `favorites#index` |
|  POST | |  `/favorites` |        |   `favorites#create` |
| GET  | |  `/favorites/:id` |     |  `favorites#show` |
|   PATCH | | `/favorites/:id` |    |   `favorites#update` |
|   PUT  | |  `/favorites/:id` |    |   `favorites#update` |
|   DELETE | | `/favorites/:id `|   |    `favorites#destroy`|
| GET  | |  `/pictures` |         |   `pictures#index` |
|   POST  | `/pictures` |    |        `pictures#create` |
| GET  | |  `/pictures/:id` |    |    `pictures#show` |
|   PATCH | | `/pictures/:id` |    |    `pictures#update` |
|   PUT | |   `/pictures/:id` |   |     `pictures#update` |
|   DELETE | | `/pictures/:id` |     |   `pictures#destroy` |
| GET  | |  `/search` |           |   `search#index` |
|     POST  | | `/search` |          |    `search#create` |
| GET   | | `/search/:id` |        |  `search#show` |
|   PATCH | | `/search/:id` |      |    `search#update` |
|   PUT  | |  `/search/:id` |     |     `search#update` |
|   DELETE  |  | `/search/:id` |    |      `search#destroy` |
| POST  |  |   `/sign-up` |       |      `users#signup` |
| POST |  |  `/sign-in` |         |    `users#signin` |
|   DELETE   |  |`/sign-out/:id` |     |   `users#signout` |
|   PATCH   |   | `/change-password/:id` |   | `users#changepw` |
| GET  |  |  `/users` |          |     `users#index` |
| GET  |  |  `/users/:id` |        |   `users#show` |
| POST |  |  `/search/sounds` |    |   `searches#sounds_search` |
| POST  |  | `/search/patents` |   |   `searches#patents_search` |
| POST  |  | `/search/mars` |     |    `searches#mars_search` |
| POST  |  | `/search/apod/today` |    | `searches#apod_today` |
| POST  |   | `/search/apod` |    |     `searches#apod_search` |
| POST  |   | `/search/neo/today` |   |  `searches#neo_today` |
