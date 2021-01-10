var gulp = require("gulp");
var template_cache = require("gulp-angular-templatecache");
var clean = require("gulp-clean");
var concat = require("gulp-concat");
var rename = require("gulp-rename");
var watch = require("gulp-watch");
var fs = require('fs');

var target = "../static/";

gulp.task("build-js", function() {
  return gulp
    .src([
      "main/main.js",
      "main/js/**/*.js",
      "modules/*/module.js",
      "modules/*/js/**/*.js"
    ])
    .pipe(concat("js/app.js"))
    .pipe(gulp.dest(target));
});

gulp.task("build-templates", function() {
  return gulp
    .src(["main/templates/**/*.html", "modules/*/templates/**/*.html"])
    .pipe(template_cache("**", { standalone: true }))
    .pipe(concat("js/templates.js"))
    .pipe(gulp.dest(target));
});

gulp.task("build-css", function() {
  return gulp
    .src([
      "node_modules/bootstrap/dist/css/bootstrap.min.css"
    ])
    .pipe(concat("css/styles.css"))
    .pipe(gulp.dest(target));
});

gulp.task("build-deps", function() {
  var jsFiles = [
    "node_modules/jquery/dist/jquery.js",
    "node_modules/lodash/lodash.js",
    "node_modules/angular/angular.js",
    "node_modules/angular-route/angular-route.js",
    "node_modules/restangular/dist/restangular.js",
    "node_modules/bootstrap/dist/js/bootstrap.js"
  ];
  return gulp
    .src(jsFiles)
    .pipe(concat("js/dependencies.js"))
    .pipe(gulp.dest(target));
});

gulp.task("clean", function() {
  return gulp.src(target, { read: false }).pipe(clean());
});

gulp.task("default", ["build"]);

gulp.task("build", [
  "build-js",
  "build-deps",
  "build-templates",
  "build-css"
]);

gulp.task("watch", ["build"], function() {
  gulp.watch("main/**/*.js", ["build"]);
  gulp.watch("main/**/*.html", ["build"]);
});
