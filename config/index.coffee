#### Config file
# Sets application config parameters depending on `env` name
exports.setEnvironment = (app) ->
  env = app.get('env') or process.env.NODE_ENV
  console.log "set app environment: #{env}"
  switch(env)
    when "development"
      settings =
        DEBUG_LOG: true
        DEBUG_WARN: true
        DEBUG_ERROR: true
        DEBUG_CLIENT: true
        REDIS_URL: "redis://redis:redis@localhost:6379/"

    when "testing"
      settings =
        DEBUG_LOG: true
        DEBUG_WARN: true
        DEBUG_ERROR: true
        DEBUG_CLIENT: true
        REDIS_URL: process.env.REDIS_URL or process.env.REDISTOGO_URL or process.env.REDISCLOUD_URL

    when "production"
      settings =
        DEBUG_LOG: false
        DEBUG_WARN: false
        DEBUG_ERROR: true
        DEBUG_CLIENT: false
        REDIS_URL: process.env.REDIS_URL or process.env.REDISTOGO_URL or process.env.REDISCLOUD_URL
    else
      exports.setEnvironment "development"
      
  for key, value of settings
    app.set key, value