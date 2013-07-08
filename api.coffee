
module.exports = (app, io) ->
  
  app.all '/socketeer/:ns/:method/:identifier?', (req, res, next) ->
    switch req.params.method
      when 'emit'
        res.send('emitted')
      when 'broadcast'
        res.send('broadcast now!')
      else
        res.send('Hey there!')