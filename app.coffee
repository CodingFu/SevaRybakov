util = require 'util'
fs = require 'fs'
http = require 'http'


responder = (req, res) ->
    
  # Doing some routing
  url = 
    switch req.url
      when '/' then '/index.html' 
      else req.url 
  
  # Guessing Content-type
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


################# Launching the server ####################

server = http.createServer(responder)
             .listen port = process.env.PORT || 3000

util.puts "running on port #{port}"