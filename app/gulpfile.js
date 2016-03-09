var gulp = require('gulp');
var less = require('gulp-less');
var path = require('path');
var plumber = require('gulp-plumber');
var nodemon = require('gulp-nodemon');
var browserSync = require('browser-sync');
var pleeease = require('gulp-pleeease');

gulp.task('css', function () {
  gulp.src('./assets/less/*.less')
    .pipe(plumber())
    .pipe(less({
      paths: [ path.join(__dirname, 'less', 'includes') ]
    }))
    .pipe(pleeease({
      autoprefixer: {
        browsers: ['last 2 versions']
      },
      minifier: false
    }))
    .pipe(gulp.dest('./public/stylesheets'))
});

gulp.task('nodemon', function(cb) {
  var called = false;
  nodemon({
        script: './app.js',
        ext: 'js html css ejs',
        ignore: ['node_modules'],
        env: {
            NODE_ENV: 'development'
        }
  })
  .on('start', function() {
    if (!called) {
        called = true;
        cb();
    }
  })
  .on('restart', function() {
        setTimeout(function() {
        browserSync.reload();
     }, 500);
  });
});

gulp.task('browser-sync', ['nodemon'], function() {
    browserSync.init(null, {
        proxy: 'http://localhost:3000',
        port: 8000
    });
});

gulp.task('default', ['browser-sync'],  function () {
  gulp.watch('./assets/less/*.less', ['css']);
});