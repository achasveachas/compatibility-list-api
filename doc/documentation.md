# Overview

Here you will find the resources that make up the Compatibility List API v1.

If you have any problems or issues please leave an issue or contact the [Yechiel Kalmenson](mailto:ykalmenson@fidelitypayment.com).

## Schema

All API access is over HTTPS, and accessed through the endpoint

`localhost:3000/api/v1/`

All data is sent and received as JSON.

## Authentication

Resources are only available to authenticated users. Authentication is verified by sending an Authentication Token with the header for the request:

`Authorization: Bearer [TOKEN]`

Sending a request without a token will return a status of `403` and the error:

```javascript
{
  errors: [
    {message: "You must include a JWT token"}
  ]
}
```

Sending an invalid token will return the error `{message: "Token is invalid"}`

## Routes

The App Tracker API uses standard RESTful routing, hee is an overview of the available routes:

### Logging In

Logging in is accomplished via `POST` request to `/auth`

```javascript
{
  user: {
    username: [USERNAME],
    password: [PASSOWRD]
  }
}
```

The response will be a user object with a token that can be used for future authentication:

```javascript
{
  user: {
    id: [USER_ID],
    username: [USERNAME],
    name: [NAME],
    admin: [BOOL]
  },
  token: [TOKEN]
}
```

Sending a bad username/password will return a `403` with an error:

```javascript
{
  errors: [ERROR_MESSAGES]
}
```

### Refresh

If you already have a token and want to retrieve the user information, send an authenticated `POST` request to `/auth/refresh`. The response will be the same as for the login request.

## Users

### Sign Up

Only Authenticated administrators can create users.
Creating a new user is accomplished via `POST` request to `/users`:

```javascript
{
  user: {
    username: [USERNAME],
    name: [NAME] (optional),
    password: [PASSOWRD]
  }
}
```

The response will be the new User with a token:

```javascript
{
  user: {
    id: [USER_ID],
    username: [USERNAME],
    name: [NAME],
    admin: [BOOL]
  },
  token: [TOKEN]
}
```

Sending invalid credentials will return a `500` status and array of errors:

```javascript
{
  errors: [ERROR_MESSAGES]
}
```

### Show User

To get the informationfor an (unauthenticated) user, send a `GET` request to `/users/:user_id`, the server will respond with a User object:

```javascript
{
  user: {
    id: [USER_ID],
    username: [USERNAME],
    name: [NAME],
    admin: [BOOL]
  }
}
```

## Applications

### index

To see all of the Applications send a `GET` request to `/applications`. The response will be an array of Application objects:

```javascript
{
  applications: [
    {
      "id": [APPLICATION_ID],
      "user_id": [USER_ID],
      "software": [SOFTWARE],
      "gateway": [GATEWAY],
      "omaha": [OMAHA],
      "nashville": [NASHVILLE],
      "north": [NORTH],
      "elavon": [ELAVON],
      "tsys": [TSYS],
      "buypass": [BUYPASS],
      "notes": [NOTES],
      "source": [SOURCE],
      "agent": [AGENT],
      "ticket": [TICKET],
      "created_at": [TIMESTAMP],
      "updated_at": [TIMESTAMP]
    }
  ]
}
```

### Show

To see an individual application send a `GET` request to `/applications/:application_id`. The response will be an Application object:

```javascript
{
  application: {
    "id": [APPLICATION_ID],
    "user_id": [USER_ID],
    "software": [SOFTWARE],
    "gateway": [GATEWAY],
    "omaha": [OMAHA],
    "nashville": [NASHVILLE],
    "north": [NORTH],
    "elavon": [ELAVON],
    "tsys": [TSYS],
    "buypass": [BUYPASS],
    "notes": [NOTES],
    "source": [SOURCE],
    "agent": [AGENT],
    "ticket": [TICKET],
    "created_at": [TIMESTAMP],
    "updated_at": [TIMESTAMP]
  }
}
```

### Create/Update

To Create a new Application send an authenticated `POST` request to `/applications`.
To update an existing Application send an authenticated `PATCH` request to `/applications/:id`.

```javascript
{
  application: {
    "id": [APPLICATION_ID],
    "user_id": [USER_ID],
    "software": [SOFTWARE],
    "gateway": [GATEWAY],
    "omaha": [OMAHA],
    "nashville": [NASHVILLE],
    "north": [NORTH],
    "elavon": [ELAVON],
    "tsys": [TSYS],
    "buypass": [BUYPASS],
    "notes": [NOTES],
    "source": [SOURCE],
    "agent": [AGENT],
    "ticket": [TICKET],
    "created_at": [TIMESTAMP],
    "updated_at": [TIMESTAMP]
  }
}
```

In both cases, the response will be the created/updated Application object:

```javascript
{
  application: {
    "id": [APPLICATION_ID],
    "user_id": [USER_ID],
    "software": [SOFTWARE],
    "gateway": [GATEWAY],
    "omaha": [OMAHA],
    "nashville": [NASHVILLE],
    "north": [NORTH],
    "elavon": [ELAVON],
    "tsys": [TSYS],
    "buypass": [BUYPASS],
    "notes": [NOTES],
    "source": [SOURCE],
    "agent": [AGENT],
    "ticket": [TICKET],
    "created_at": [TIMESTAMP],
    "updated_at": [TIMESTAMP]
  }
}
```

### Delete

To delete an Application send an authenticated `DELETE` request to `/applications/:id`. The response will be a `204` status.
