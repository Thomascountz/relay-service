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
GET /hello

Returns "Hello, World"
```

```
POST /hello 
Parameters: name<string>

Returns {"response": "Hello, <<name>>"}
```

```
POST /sentiment/analyze

body (required): JSON object | String
__________________________________________________________
{ 
  "text": "Text to be analyzed"
}
Plain text input that contains the content to be analyzed. 
__________________________________________________________

headers (required):
__________________________________________________________
Content-Type: application/json
__________________________________________________________

Returns JSON formatted tone analysis for the given text. 
See example below

```

```
GET /sentiment/analyze

params (required): 
__________________________________________________________
text
?text=encoded%20string

You must URL-encode the input.
Encoded text input that contains the content to be analyzed. 
__________________________________________________________

Returns JSON formatted tone analysis for the given text.
See example below.

```


## Example:

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

## Development

### Installation 
  - Clone this repo: https://github.com/Thomascountz/relay-service.git
  - cd into relay-service
  - Run `mix deps.get`
  - Hack away!
  
### Environment Variables

```
IBM_WATSON_TONE_ANALYZER_URL
IBM_WATSON_TONE_ANALYZER_KEY
```

There are two environment variables that relay-service needs, both of which can be aquired by creating a free acount and signing up for IBM Watson Tone Analyzer Service. After signing up, the url and key are on your dashboard, under "credentials."

Sign up here: https://www.ibm.com/watson/services/tone-analyzer/


### Running Unit Tests

```
mix test
```

Runs unit tests, which utilizes port `4001` on `localhost`

### Running Development Server

```
iex -S mix
```

Runs plug on `localhost:4000`

### Deploy

1. Create a Heroku Application

``` 
$ heroku create
```

2. Add Elixir Buildpack

```
$ heroku buildpacks:set https://github.com/HashNuke/heroku-buildpack-elixir
```

3. Push to Heroku
```
$ git push heroku master
```

4. Set Environment Variables on Heroku
```
$ heroku config:set IBM_WATSON_TONE_ANALYZER_KEY=<YOUR API KEY>
$ heroku config:set IBM_WATSON_TONE_ANALYZER_URL=<YOUR WATSON TONE ANALYZER URL>
```

### Issues and Bug Tracking
https://github.com/Thomascountz/relay-service/issues
