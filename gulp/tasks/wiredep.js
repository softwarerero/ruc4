var gulp = require('gulp');

// inject bower components
gulp.task('wiredep', function() {
  var wiredep = require('wiredep').stream;

  gulp.src('client/app/*.html')
    .pipe(wiredep({
      directory: 'client/app/bower_components'
    }))
    .pipe(gulp.dest('client/app'));
});
