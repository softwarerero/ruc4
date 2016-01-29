var path = require('path');
var gulp = require('gulp');
var autoprefixer = require('gulp-autoprefixer');
var less = require('gulp-less');
//var css = require('gulp-css');
var sourcemaps = require('gulp-sourcemaps');
var size = require('gulp-size');
var uglifycss = require('gulp-uglifycss');

gulp.task('styles', function () {
  return gulp.src('client/app/styles/main.less')
    .pipe(less({
      paths: ['client/app/styles/includes', 'client/app/styles/libs']
    }))
    .pipe(autoprefixer('last 1 version'))
    .pipe(uglifycss({
      "max-line-len": 80
    }))
    .pipe(gulp.dest('dist/styles'))
    .pipe(size());
});
