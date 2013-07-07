express = require 'express'
redis = require 'redis'
sio = require 'socket.io'
RedisStore = require 'socket.io/lib/stores/redis'

redis.debug_mode = true

app = express()
exports.app = app
require("./config")(app)
console.log app.get('REDIS_URL')

app.disable('x-powered-by') # Sthealt!

server = require("http").createServer(app)
# Define Port
server.port = process.env.PORT or process.env.VMC_APP_PORT or 3000
module.exports = server

io = sio.listen(server)
io.configure ->
  createRedisSocket = (url) ->
    _url = require 'url'
    redis = require 'socket.io/node_modules/redis'
    console.log app.get('REDIS_URL')
    redisURL = _url.parse url
    client = redis.createClient Number(redisURL.port), redisURL.hostname
    client.auth redisURL.auth.split(":")[1], (err) ->
      throw err if err
    client
  pubsub = {}
  for sock in "pub sub client".split()
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