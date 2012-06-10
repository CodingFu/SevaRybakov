util = require 'util'
fs = require 'fs'
http = require 'http'

visits = 0

responder = (req, res) ->
  # Tracking visits
  visits += 1 if req.url == '/'
  
  if req.url == '/visits'
    res.writeHead 200, "Content-type" : "text/plain"
    res.end "Visits: #{visits}"
    
  # Doing some routing
  url = 
    if req.url == '/'
      '/index.html' 
    else if req.url == '/cv'
      '/cv.html'
    else if req.url == '/posts/latest'
      '/posts/hello.md'
    else req.url 
  
  # Guessing Content-type
  head = {}
  head['Content-Type'] = (
    if /.*\.html/.test url
      'text/html'
    else if /.*\.css/.test url
      'text/css'
    else if /.*\.js/.test url
      'text/javascript'
    else
      'text/plain'
  )+ '; charset=utf-8'
  
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