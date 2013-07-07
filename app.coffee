express = require 'express'
redis = require 'redis'
sio = require 'socket.io'
RedisStore = require 'socket.io/lib/stores/redis'

redis.debug_mode = false

app = express()
# Config module exports has `setEnvironment` function that sets app settings depending on environment.
config = require "./config"
app.configure 'production', 'development', 'testing', ->
  for key, value of config.setEnvironment app.settings.env
    app.set key, value

  app.disable('x-powered-by') # Sthealt!

  server = require("http").createServer(app)
  # Define Port
  server.port = process.env.PORT or process.env.VMC_APP_PORT or 3000
  module.exports = server

  createRedisSocket = ->
    url = require 'url'
    redisURL = url.parse app.get('REDIS_URL')
    client = redis.createClient redisURL.port, redisURL.hostname#, no_ready_check: true
    client.auth redisURL.auth.split(":")[1]
    client

  io = sio.listen(server)
  io.configure ->
    io.set "transports", ["xhr-polling"]
    io.set "polling duration", 10
    io.set 'log level', 1
    io.set "store", new RedisStore(
      redisPub: createRedisSocket()
      redisSub: createRedisSocket()
      redisClient: createRedisSocket()
    )

  io.sockets.on "connection", (socket) ->  
    socket.emit 'connect', 'yolo'

app.get '/', (req, res) ->
  res.send('Hello World')