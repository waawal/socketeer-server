
module.exports = (app, io) ->
  
  app.all '/socketeer/:method/:identifier?', (req, res, next) ->
    res.send('Hey there!')