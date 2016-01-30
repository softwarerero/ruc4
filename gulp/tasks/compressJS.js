var gulp = require('gulp');
//var autoprefixer = require('gulp-autoprefixer');
//var less = require('gulp-less');
////var css = require('gulp-css');
//var sourcemaps = require('gulp-sourcemaps');
//var size = require('gulp-size');
//var uglifycss = require('gulp-uglifycss');
var uglify = require('gulp-uglify');


gulp.task('compressJS', ['browserify'], function() {
  console.log('compressJS');
  return gulp.src('dist/scripts/*.js')
    .pipe(uglify())
    .pipe(gulp.dest('dist/scripts'));
});