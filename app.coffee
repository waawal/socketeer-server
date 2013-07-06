cluster = require 'cluster'
express = require 'express'
redis = require 'redis'
sio = require 'socket.io'

redis.debug_mode = false

app = express()
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
module.exports = server

RedisSocket = ->
  url = require 'url'
  redisURL = url.parse app.get('REDIS_URL')
  client = redis.createClient redisURL.port, redisURL.hostname, no_ready_check: true
  client.auth redisURL.auth.split(":")[1]
  client

io.sockets.on "connection", (socket) ->  
  socket.emit 'connect', 'yolo'

app.get '/', (req, res) ->
  res.send('Hello World')