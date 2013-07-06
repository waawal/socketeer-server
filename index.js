var server, port;
require('coffee-script')
server = require('./app');
port = server.port;
server.listen(port, function() {
  return console.log("Listening on " + port + "\nPress CTRL-C to stop server.");
});
