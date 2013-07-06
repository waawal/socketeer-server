express = require 'express'
redis = require 'redis'
sio = require 'socket.io'

redis.debug_mode = false
# Config module exports has `setEnvironment` function that sets app settings depending on environment.
config = require "./config"
app.configure 'production', 'development', 'testing', ->
  config.setEnvironment app.settings.env

app.disable('x-powered-by') # Sthealt!

server = require("http").createServer(app)

io = sio.listen(server)
  io.configure ->
    io.set "transports", ["xhr-polling"]
    io.set "polling duration", 10
    io.set 'log level', 1

# Define Port
server.port = process.env.PORT or process.env.VMC_APP_PORT or 3000

io.sockets.on "connection", (socket) ->  
  socket.emit 'connect', 'yolo'

createRedisSocket = (serviceUrl) ->
  url = require 'url'
  redisURL = url.parse app.get(serviceUrl)
  client = redis.createClient redisURL.port, redisURL.hostname, no_ready_check: true
  client.auth redisURL.auth.split(":")[1]
  return client