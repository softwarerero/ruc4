var gulp = require('gulp');
var livereload = require('gulp-livereload');

// Determine watchify/browserify
gulp.task('setWatch', function() {
  global.isWatching = true;
});

gulp.task('watch', ['setWatch','connect', 'serve'], function() {
  var server = livereload({ start: true });
  
  // watch for changes
  var watchPath = [
    'client/app/*.html',
//    'client/.tmp/styles/**/*.css',
    '{client/app}/scripts/**/*.js',
    'client/app/images/**/*'
  ];

  gulp.watch(watchPath).on('change', function(file) {
    livereload.changed(file.path);
  });

  gulp.watch('client/app/**/*.html', ['html']);
  gulp.watch('client/app/styles/**/*.less', ['styles']);
  gulp.watch('client/app/scripts/**/*.coffee', ['compressJS']);
  gulp.watch('client/app/images/**/*', ['images']);
  gulp.watch('client/bower.json', ['wiredep']);
});
