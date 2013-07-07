
module.exports = (app, io) ->
  
  app.all '/socketeer/:method/:identifier?', (req, res, next) ->
    res.send(req.get('Content-Type'))