var gulp = require('gulp');
var run = require('gulp-run');

gulp.task('clean', function(cb) {
  run('rm -rf dist dist').exec(cb);
});
