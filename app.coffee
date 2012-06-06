util = require 'util'
fs = require 'fs'
http = require 'http'

responder = (req, res) ->
  
  # Doing some routing
  url = 
    switch req.url
      when '/' then '/index.html'
      else req.url 
  
  # Guessing fileType
  head = {}
  head['Content-Type'] =
    if /.*\.html/.test url
      'text/html'
    else if /.*\.css/.test url
      'text/css'
    else if /.*\.js/.test url
      'text/javascript'
    else
      'text/plain'
  
  # Trying to read body
  body = ''
  try
    body = fs.readFileSync('public' + url)
    res.writeHead 200, head
  catch error
    res.writeHead 404, 'Content-Type' : 'text/plain'
    body = 'Oops... 404'
  res.end body

server = http.createServer(responder)
             .listen port = 80

util.log "Server is running at port #{port}"