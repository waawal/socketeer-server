#### Config file
# Sets application config parameters depending on `env` name
exports.setEnvironment = (env) ->
  console.log "set app environment: #{env}"
  switch(env)
    when "development"
      exports.DEBUG_LOG = true
      exports.DEBUG_WARN = true
      exports.DEBUG_ERROR = true
      exports.DEBUG_CLIENT = true
      exports.REDIS_URL = "redis://redis:redis@localhost:6379/"

    when "testing"
      exports.DEBUG_LOG = true
      exports.DEBUG_WARN = true
      exports.DEBUG_ERROR = true
      exports.DEBUG_CLIENT = true
      exports.REDIS_URL = process.env.REDIS_URL or process.env.REDISTOGO_URL or process.env.REDISCLOUD_URL

    when "production"
      exports.DEBUG_LOG = false
      exports.DEBUG_WARN = false
      exports.DEBUG_ERROR = true
      exports.DEBUG_CLIENT = false
      exports.REDIS_URL = process.env.REDIS_URL or process.env.REDISTOGO_URL or process.env.REDISCLOUD_URL
    else
      console.log "environment #{env} not found"
