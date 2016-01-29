var gulp = require('gulp');
var gutil = require('gulp-util');
var filter = require('gulp-filter');
var useref = require('gulp-useref');
var uglify = require('gulp-uglify');
var csso = require('gulp-csso');
var size = require('gulp-size');

gulp.task('html', ['styles', 'compressJS'], function() {
  var jsFilter = filter('**/*.js');
  var jsFilter2 = filter('**/*.js', {restore: true});
  var cssFilter = filter('**/*.css');
  var cssFilter2 = filter('**/*.css', {restore: true});
  
  return gulp.src('client/app/*.html')
    .pipe(useref({searchPath: '{dist, client/app}'}))
    .pipe(gulp.dest('dist'))
    .pipe(jsFilter)
    .pipe(uglify())
    .pipe(jsFilter2.restore)
    .pipe(cssFilter)
    .pipe(csso())
    .pipe(cssFilter2.restore)
    .pipe(gulp.dest('dist'))
    .pipe(size())
});
