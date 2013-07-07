
module.exports = (app, io) ->
  
  app.all '/socketeer/:method?/:identifier?', (req, res, next) ->
    req.get('Content-Type')