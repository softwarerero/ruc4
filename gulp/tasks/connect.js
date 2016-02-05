var gulp = require('gulp');

gulp.task('connect', function() {
  var connect = require('connect');
  var serveStatic = require('serve-static')
  var serveIndex = require('serve-index');
  var port = 9000;
  var app = connect()
    .use(require('connect-livereload')({
      port: 35729
    }))
    .use(serveStatic('client/app'))
    .use(serveStatic('dist'))
    .use(serveIndex('client/app'));

  require('http').createServer(app)
    .listen(port)
    .on('listening', function() {
      console.log('Started connect web server on http://localhost:' + port);
    });
});
