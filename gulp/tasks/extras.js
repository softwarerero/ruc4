var gulp = require('gulp');

gulp.task('extras', function() {
  return gulp.src(['client/app/*.*', '!client/app/*.html'], {
    dot: true
  })
    .pipe(gulp.dest('dist'));
});
