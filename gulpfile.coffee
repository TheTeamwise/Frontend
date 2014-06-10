"use strict"

# Require
gulp = require("gulp")
$ = require("gulp-load-plugins")()
http = require("http")

# Tasks
gulp.task "styles", ->
  gulp.src("app/styles/main.scss")
    .pipe($.sass())
    .pipe($.autoprefixer("last 1 version"))
    .pipe(gulp.dest(".tmp/styles"))
    .pipe $.size()

gulp.task "scripts", ->
  gulp.src("app/scripts/**/*.coffee")
    .pipe($.coffee())
    .pipe(gulp.dest(".tmp/scripts"))
    .pipe $.size()

gulp.task "images", ->
  gulp.src("app/images/**/*").pipe(gulp.dest("dist/images")).pipe $.size()

gulp.task "html", [ "scripts", "styles" ], ->
  filters = {
    js: $.filter(".tmp/scripts/**/*.js")
    css: $.filter(".tmp/scripts/**/*.css")
  }
  gulp.src("app/**/*.html")
    .pipe($.useref.assets().on("error", gutil.log))
    .pipe(filters.js)
    .pipe($.uglify())
    .pipe(filters.js.restore())
    .pipe(filters.css)
    .pipe($.csso())
    .pipe(filters.css.restore())
    .pipe($.useref.restore())
    .pipe($.useref())
    .pipe(gulp.dest("dist"))
    .pipe $.size()

gulp.task "fonts", ->
  # $.bowerFiles()
  gulp.src("app/bower_components/font-awesome/fonts/**.*{eot,svg,ttf,woff,otf}")
    # .pipe($.flatten())
    .pipe(gulp.dest("dist/fonts"))
    .pipe $.size()

gulp.task "clean", ->
  gulp.src([".tmp", "dist"], read: false)
    .pipe $.clean()

gulp.task "build", ["html", "images", "fonts"]

gulp.task "default", ["clean"], ->
  gulp.start "build"
  return

gulp.task "connect", ->
  connect = require("connect")
  app = connect()
          .use(require("connect-livereload")(port: 35729))
          .use(connect.static("app"))
          .use(connect.static(".tmp"))
          .use(connect.directory("app"))

  http.createServer(app).listen(9000).on "listening", ->
    console.log "Started connect web server on http://localhost:9000"
    return

  return

gulp.task "serve", ["connect", "styles", "scripts"], ->
  return

# inject bower components
gulp.task "wiredep", ->
  wiredep = require("wiredep").stream
  gulp.src("app/styles/*.scss")
    .pipe(wiredep(directory: "app/bower_components"))
    .pipe gulp.dest("app/styles")

  gulp.src("app/*.html").pipe(wiredep(
    directory: "app/bower_components"
    exclude: ["bootstrap-sass-official"]
  )).pipe gulp.dest("app")
  return

gulp.task "watch", ["connect", "serve"], ->
  server = $.livereload()

  # watch for changes
  gulp.watch([
    "app/*.html"
    "app/images/**/*"
    "app/views/**/*.html"
    ".tmp/styles/**/*.css"
    ".tmp/scripts/**/*.js"
  ]).on "change", (event) ->
    server.changed event.path
    console.log "#{event.path} was #{event.type}"
    return

  gulp.watch "app/styles/**/*.scss", ["styles"]
  gulp.watch "app/scripts/**/*.coffee", ["scripts"]
  gulp.watch "app/images/**/*", ["images"]
  gulp.watch "bower.json", ["wiredep"]
  return
