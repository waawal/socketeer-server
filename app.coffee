express = require 'express'
redis = require 'redis'
sio = require 'socket.io'
socketioWildcard = require('socket.io-wildcard')
RedisStore = require 'socket.io/lib/stores/redis'

app = express()
exports.app = app
require("./config")(app)

app.disable('x-powered-by') # Sthealt!

server = require("http").createServer(app)
# Define Port
server.port = process.env.PORT or process.env.VMC_APP_PORT or 3000
module.exports = server

io = socketioWildcard(sio).listen(server)
io.configure ->
  createRedisSocket = (url) ->
    _url = require 'url'
    redis = require 'socket.io/node_modules/redis'
    redisURL = _url.parse url
    client = redis.createClient Number(redisURL.port), redisURL.hostname, no_ready_check: true
    client.auth redisURL.auth.split(":")[1], (err) ->
      throw err if err
    client
  pubsub = {}
  for sock in ['pub', 'sub', 'client']
    pubsub[sock] = createRedisSocket app.get('REDIS_URL')
  io.set "transports", ["xhr-polling"]
  io.set "polling duration", 10
  io.set 'log level', 1
  io.set "store", new RedisStore(
    redis: require 'socket.io/node_modules/redis'
    redisPub: pubsub.pub
    redisSub: pubsub.sub
    redisClient: pubsub.client
  )

io.sockets.on "connection", (socket) ->  
  socket.emit 'connect', 'yolo'

app.get '/', (req, res) ->
  res.send('Hello World')

app.post '/emit', (req, res) ->
  io.sockets.emit('msg')