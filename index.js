var server, port, cluster;

// Include the cluster module
cluster = require('cluster');

// Code to run if we're in the master process
if (cluster.isMaster) {

  // Count the machine's CPUs
  var cpuCount = process.env.PROCESS_NUMBER || require('os').cpus().length;

  // Create a worker for each CPU
  for (var i = 0; i < cpuCount; i += 1) {
    cluster.fork();
  }

  // Listen for dying workers
  cluster.on('exit', function (worker) {

    // Replace the dead worker, we're not sentimental
    console.log('Worker ' + worker.id + ' died, spawning new.');
    cluster.fork();

  });
// Code to run if we're in a worker process
} else {
  require('coffee-script')
  server = require('./app');
  port = server.port;
  server.listen(port, function() {
    return console.log("Listening on port " + port);
  });
}
