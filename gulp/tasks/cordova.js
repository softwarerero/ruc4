var gulp = require('gulp')
del = require('del'),
  cordova = require('cordova-lib').cordova.raw;

var HOME= __dirname + '/../..',
  APP_PATH = HOME + '/client/app',
  CORDOVA_PATH = HOME + '/client/cordova/www';

gulp.task('del-cordova', function(cb) {
  console.log('dir: ' + __dirname);
  console.log('APP_PATH: ' + APP_PATH);
  console.log('CORDOVA_PATH: ' + CORDOVA_PATH);
  del([ CORDOVA_PATH + '/*' ], {force: true}, function() {
    cb();
  });
});

gulp.task('copy-cordova', [ 'del-cordova' ], function(cb) {
  var NOAPP = '!' + APP_PATH;
  console.log(NOAPP + '/{data,data/**}');
  var src = [ APP_PATH + '/**/*', HOME + '/dist/**'];
  var excludes = ['data', 'styles', 'scripts', 'bower_components'];
  excludes.forEach( function(ex) { src.push(NOAPP + '/{' + ex + ','+ ex +'/**}') });
  console.log('ex: ' + src);
  return gulp.src(src)
    .pipe(gulp.dest(CORDOVA_PATH));
});


var argv = require('yargs').argv;

gulp.task('cordova', [ 'copy-cordova', 'styles', 'compressJS' ], function(cb) {
  var device = argv.device || 'ios';
  console.log('device: ' + device);
  process.chdir(HOME + '/client/cordova');
  cordova
    .run({ platforms: [ device ] })
    .then(function() {
      process.chdir('../');
      cb();
    });
});
