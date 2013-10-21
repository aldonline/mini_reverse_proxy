
Sets up a proxy in /proxy.

Usage: `GET|POST|PUT|etc http://host/proxy?url=TARGET_URL`

TARGET_URL can be http or https

To prevent abuse we have hardcoded a whitelist ( see below )

example:

```shell
$ curl -X GET http://localhost:3001/proxy?url=http://foo.com/api/v2/magazine/summary.json
```

This is normally used for AJAX + CORS