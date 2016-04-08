Mime::Type.unregister :json
Mime::Type.register 'application/vnd.api+json', :json, %W(
  application/vnd.api+json
  text/x-json
  application/json
)
