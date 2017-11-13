# Users Service

For full Bark documentation visit [http://localhost/docs](http://localhost/docs).

## Create User

POST `/users`

*POST parameters*

Name         | Validation
------------ | -------------
username     | optional 
email        | required
password     | required

*Response [200]*

```json
{
  "id": 1,
  "username": "Bob",
  "email": "bob@test.com",
  "token": "2d931510-d99f-494a-8c67-87feb05e1594",
  "created_at": "2017-11-11 11:04:44 UTC",
  "updated_at": "2017-1-11 11:04:44 UTC"
}
```

*Error Response [422]*

```json
[
  ["email", ["must be filled"]],
  ["password", ["must be filled"]]
]
```

## Update User

POST `/users/update`

*Authorization*

To update user you need to send his token via `HTTP_AUTHORIZATION` header. Example:
`Authorization: Bearer <token>`.

*POST parameters*

Name         | Validation
------------ | -------------
username     | optional 
password     | optional

*Response [200]*

```json
{
  "id": 1,
  "username": "Bob",
  "email": "bob@test.com",
  "token": "2d931510-d99f-494a-8c67-87feb05e1594",
  "created_at": "2017-11-11 11:04:44 UTC",
  "updated_at": "2017-1-11 11:04:44 UTC"
}
```

*Error Response [401]*

No token provided

*Error Response [404]*

Usr not found via provided token

## Get User By Token

GET `/users/by_token`

*Token*

To get user you need to send his token via `HTTP_AUTHORIZATION` header. Example:
`Authorization: Bearer <token>`.

*Response [200]*

```json
{
  "id": 1,
  "username": "Bob",
  "email": "bob@test.com",
  "token": "2d931510-d99f-494a-8c67-87feb05e1594",
  "created_at": "2017-11-11 11:04:44 UTC",
  "updated_at": "2017-1-11 11:04:44 UTC"
}
```

*Error Response [404]*

User not found via provided token.

## Find by Email and Password

POST `/users/by_email_password`

*POST parameters*

Name         | Validation
------------ | -------------
email        | optional 
password     | optional

*Response [200]*

```json
{
  "id": 1,
  "username": "Bob",
  "email": "bob@test.com",
  "token": "2d931510-d99f-494a-8c67-87feb05e1594",
  "created_at": "2017-11-11 11:04:44 UTC",
  "updated_at": "2017-1-11 11:04:44 UTC"
}
```

*Error Response [404]*

User not found via provided email and password.

*Error Response [422]*

```json
[
  ["email", ["must be filled"]],
  ["password", ["must be filled"]]
]
```