#### Config file
# Sets application config parameters depending on `env` name
exports.setEnvironment = (env) ->
  console.log "set app environment: #{env}"
  switch(env)
    when "development"
      settings =
        DEBUG_LOG: true
        DEBUG_WARN: true
        DEBUG_ERROR: true
        DEBUG_CLIENT: true
        REDIS_URL: "redis://redis:redis@localhost:6379/"
      return settings

    when "testing"
      settings =
        DEBUG_LOG: true
        DEBUG_WARN: true
        DEBUG_ERROR: true
        DEBUG_CLIENT: true
        REDIS_URL: process.env.REDIS_URL or process.env.REDISTOGO_URL or process.env.REDISCLOUD_URL
      return settings

    when "production"
      settings =
        DEBUG_LOG: false
        DEBUG_WARN: false
        DEBUG_ERROR: true
        DEBUG_CLIENT: false
        REDIS_URL: process.env.REDIS_URL or process.env.REDISTOGO_URL or process.env.REDISCLOUD_URL
      return settings
    else
      exports.setEnvironment "development"
