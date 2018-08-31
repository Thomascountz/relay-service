# Relay Sevice
[![Build Status](https://semaphoreci.com/api/v1/thomascountz1/relay-service/branches/master/badge.svg)](https://semaphoreci.com/thomascountz1/relay-service)

API endpoint for [Relay Text Editor's NPL Analysis](https://github.com/Thomascountz/relay)

```
https://frozen-hollows-25947.herokuapp.com
```

Endpoints

```
GET /hello

Returns "Hello, World"
```

```
POST /hello 
Parameters: name<string>

Returns {"response": "Hello, <<name>>"}
```

Examples:

```
curl https://frozen-hollows-25947.herokuapp.com/hello

#=> Hello, World!
```

```
curl https://frozen-hollows-25947.herokuapp.com -H "content-type: application/json" -X POST -d '{"name":"Mandy"}'

#=> {"response":"Hello, Mandy!"}
```
