express = require 'express'
redis = require 'redis'
sio = require 'socket.io'
RedisStore = require 'socket.io/lib/stores/redis'

redis.debug_mode = false

app = express()
exports.app = app
require("./config")(app)

app.disable('x-powered-by') # Sthealt!

server = require("http").createServer(app)
# Define Port
server.port = process.env.PORT or process.env.VMC_APP_PORT or 3000
module.exports = server

createRedisSocket = ->
  url = require 'url'
  redisURL = url.parse exports.app.get('REDIS_URL')
  client = redis.createClient redisURL.port, redisURL.hostname#, no_ready_check: true
  client.auth redisURL.auth.split(":")[1]
  client

pubsub = {}
for sock in "pub sub client".split()
  pubsub[sock] = createRedisSocket()

io = sio.listen(server)
io.configure ->
  io.set "transports", ["xhr-polling"]
  io.set "polling duration", 10
  io.set 'log level', 1
  io.set "store", new RedisStore(
    redisPub: pubsub.pub
    redisSub: pubsub.sub
    redisClient: pubsub.client
  )

io.sockets.on "connection", (socket) ->  
  socket.emit 'connect', 'yolo'

app.get '/', (req, res) ->
  res.send('Hello World')