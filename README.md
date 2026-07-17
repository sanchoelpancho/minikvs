minikvs
=======

An in-memory key-value store, accessible over HTTP (built with Cowboy) and backed by Mnesia (RAM-only schema).

Build
-----

    $ rebar3 compile

Run
---

    $ rebar3 shell

This starts the application, initializes the in-memory database, and starts the HTTP listener on port `8080`.

To stop the node: `Ctrl+G` then `q`, or `Ctrl+C` (`q().` alone is not working for some reason and I could not fix it yet).

API
---

All request and response bodies are JSON. All keys are treated as strings (UTF-8 binaries) on the Erlang side.

### Set a value — `PUT /kvs`

Creates or overwrites the value stored for a key.

**Request body:**
```json
{
    "key": "messi",
    "data": 10
}
```

**Response — `200 OK`:**
```json
{
    "status": "added",
    "key": "messi",
    "data": 10
}
```

### Get a value — `GET /kvs/:key`

Retrieves the value stored for `:key`.

**Example:** `GET /kvs/messi`

**Response — `200 OK`** (key found):
```json
{
    "status": "found",
    "key": "messi",
    "data": 10
}
```

**Response — `404 Not Found`** (no data associated with the key):
```json
{
    "status": "key not found"
}
```

### Clear a value — `DELETE /kvs/:key`

Removes any value associated with `:key`. Succeeds whether or not the key previously had data — after this call, `GET /kvs/:key` will behave as if the key was never set.

**Example:** `DELETE /kvs/messi`

**Response — `200 OK`:**
```json
{
    "status": "removed",
    "key": "messi"
}
```

### Unsupported methods

Any method other than `GET`, `PUT`, or `DELETE` on these routes returns:

**Response — `405 Method Not Allowed`**

Example usage with curl
------------------------

```bash
# Set a value
curl -X PUT http://localhost:8080/kvs \
  -H "Content-Type: application/json" \
  -d '{"key": "messi", "data": 10}'

# Get it back
curl http://localhost:8080/kvs/messi

# Clear it
curl -X DELETE http://localhost:8080/kvs/messi

# Confirm it's gone
curl http://localhost:8080/kvs/messi
```