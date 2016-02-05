var gulp = require('gulp');

gulp.task('serve', ['connect', 'styles', 'compressJS'], function() {
  require('opn')('http://localhost:4000');
});
