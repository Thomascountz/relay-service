# Relay Sevice
[![Build Status](https://semaphoreci.com/api/v1/thomascountz1/relay-service/branches/master/badge.svg)](https://semaphoreci.com/thomascountz1/relay-service)

API endpoint for [Relay Text Editor's NPL Analysis](https://github.com/Thomascountz/relay)

### STAGING
```
https://frozen-hollows-25947.herokuapp.com
```

### PRODUCTION
```
https://relay-service.herokuapp.com
```

#### Production Endpoints

```
GET /sentiment/analyze

params: 
__________________________________________________________
text
?text=encoded%20string

Required query string parameter. 
You must URL-encode the input.
Plain text input that contains the content to be analyzed. 
__________________________________________________________

Returns JSON formatted tone analysis for the given text.
Read more about the underlying API that powers this endpoint here: https://www.ibm.com/watson/developercloud/tone-analyzer/api/v3/curl.html?curl#get-tone

```

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
curl "https://relay-service.herokuapp.com/sentiment/analyze?text=I%20love%20how%20beautiful%20the%20winter%20sky%20looks%2C%20today%21%20Such%20a%20clear%20rich%20blue%2C%20contrasted%20by%20the%20pure%20bleach-white%20snow%21"

#=> {
  "document_tone": {
    "tones": [
      {
        "score": 0.894487,
        "tone_id": "joy",
        "tone_name": "Joy"
      },
      {
        "score": 0.596122,
        "tone_id": "analytical",
        "tone_name": "Analytical"
      },
      {
        "score": 0.965244,
        "tone_id": "confident",
        "tone_name": "Confident"
      }
    ]
  },
  "sentences_tone": [
    {
      "sentence_id": 0,
      "text": "I love how beautiful the winter sky looks, today!",
      "tones": [
        {
          "score": 0.91671,
          "tone_id": "joy",
          "tone_name": "Joy"
        }
      ]
    },
    {
      "sentence_id": 1,
      "text": "Such a clear rich blue, contrasted by the pure bleach-white snow!",
      "tones": [
        {
          "score": 0.688669,
          "tone_id": "joy",
          "tone_name": "Joy"
        },
        {
          "score": 0.653099,
          "tone_id": "analytical",
          "tone_name": "Analytical"
        },
        {
          "score": 0.913755,
          "tone_id": "confident",
          "tone_name": "Confident"
        }
      ]
    }
  ]
}

Read more about the underlying API that powers this endpoint here:
https://www.ibm.com/watson/developercloud/tone-analyzer/api/v3/curl.html?curl#get-tone
```

```
curl https://relay-service.herokuapp.com/hello

#=> Hello, World!
```

```
curl https://relay-service.herokuapp.com -H "content-type: application/json" -X POST -d '{"name":"Mandy"}'

#=> {"response":"Hello, Mandy!"}
```
