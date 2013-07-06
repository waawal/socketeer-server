express = require 'express'
redis = require 'redis'
sio = require 'socket.io'
RedisStore = require 'socket.io/lib/stores/redis'

redis.debug_mode = false

app = express()
# Config module exports has `setEnvironment` function that sets app settings depending on environment.
config = require "./config"
app.configure 'production', 'development', 'testing', ->
  config.setEnvironment app.settings.env

app.disable('x-powered-by') # Sthealt!

server = require("http").createServer(app)
# Define Port
server.port = process.env.PORT or process.env.VMC_APP_PORT or 3000
module.exports = server

io = sio.listen(server)
io.configure ->
  io.set "transports", ["xhr-polling"]
  io.set "polling duration", 10
  io.set 'log level', 1

RedisSocket = ->
  url = require 'url'
  redisURL = url.parse(process.env.REDISCLOUD_URL) # TODO: Fix config app.get('REDIS_URL') or process.env.REDISTOGO_URL or
  client = redis.createClient redisURL.port, redisURL.hostname, no_ready_check: true
  client.auth redisURL.auth.split(":")[1]
  client

pub = redis.createClient()
sub = redis.createClient()
client = redis.createClient()
io.set "store", new RedisStore(
  redisPub: RedisSocket()
  redisSub: RedisSocket()
  redisClient: RedisSocket()
)

io.sockets.on "connection", (socket) ->  
  socket.emit 'connect', 'yolo'

app.get '/', (req, res) ->
  res.send('Hello World')