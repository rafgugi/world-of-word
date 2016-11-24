'use strict';

var plugins    = require('gulp-load-plugins');
var yargs      = require('yargs');
var gulp       = require('gulp');
var panini     = require('panini');
var rimraf     = require('rimraf');
var yaml       = require('js-yaml');
var fs         = require('fs');
var coffee     = require('gulp-coffee');
var browser    = require('browser-sync');
var browserify = require('gulp-browserify');
var concat     = require('gulp-concat');
var rename     = require('gulp-rename');
var gls        = require('gulp-live-server');

// Load all Gulp plugins into one variable
const $ = plugins();

// Check for --production flag
const PRODUCTION = !!(yargs.argv.production);

// Load settings from settings.yml
var ref = loadConfig();
const COMPATIBILITY = ref.COMPATIBILITY;
const PORT = ref.PORT;
const UNCSS_OPTIONS = ref.UNCSS_OPTIONS;
const PATHS = ref.PATHS;

// intialize game server
var game = gls.new(PATHS.dist.server + '/game.js')

function loadConfig() {
  let ymlFile = fs.readFileSync('config.yml', 'utf8');
  return yaml.load(ymlFile);
}

// Build the "dist" folder by running all of the below tasks
gulp.task('build',
 gulp.series(clean, gulp.parallel(pages, sass, javascript, compileReact, compileServer, images, copy)));

// Build the site, run the server, and watch for file changes
gulp.task('default',
  gulp.series('build', gulp.parallel(server, browserInit), watch));

// Delete the "dist" folder
// This happens every time a build starts
function clean(done) {
  rimraf(PATHS.dist.root, done);
}

// Copy files out of the assets folder
// This task skips over the "img", "js", and "scss" folders, which are parsed separately
function copy() {
  return gulp.src(PATHS.assets)
    .pipe(gulp.dest(PATHS.dist.client + '/assets'));
}

// Copy page templates into finished HTML files
function pages() {
  return gulp.src('src/pages/**/*.{html,hbs,handlebars}')
    .pipe(panini({
      root: 'src/pages/',
      layouts: 'src/layouts/',
    }))
    .pipe(gulp.dest(PATHS.dist.client));
}

// Load updated HTML templates into Panini
function resetPages(done) {
  panini.refresh();
  done();
}

// Compile Sass into CSS
// In production, the CSS is compressed
function sass() {
  return gulp.src('src/assets/scss/app.scss')
    .pipe($.sourcemaps.init())
    .pipe($.sass({
      includePaths: PATHS.sass
    })
      .on('error', $.sass.logError))
    .pipe($.autoprefixer({
      browsers: COMPATIBILITY
    }))
    .pipe($.if(PRODUCTION, $.cssnano()))
    .pipe($.if(!PRODUCTION, $.sourcemaps.write()))
    .pipe(gulp.dest(PATHS.dist.client + '/assets/css'))
    .pipe(browser.reload({ stream: true }));
}

// Combine JavaScript into one file
// In production, the file is minified
function javascript() {
  return gulp.src(PATHS.javascript)
    .pipe($.sourcemaps.init())
    // .pipe($.babel()) if you activate this, socket.io won't work
    .pipe($.concat('app.js'))
    .pipe($.if(PRODUCTION, $.uglify()
      .on('error', function(e) { console.log(e); })
    ))
    .pipe($.if(!PRODUCTION, $.sourcemaps.write()))
    .pipe(gulp.dest(PATHS.dist.client + '/assets/js'));
}

// Compile react in coffeescript into javascript
function compileReact() {
  return gulp.src('./src/react/index.coffee', { read: false })
    .pipe(browserify({ transform: ['coffeeify'], extensions: ['.coffee'] }))
    .pipe(concat('app2.js'))
    .pipe($.if(PRODUCTION, $.uglify()
      .on('error', function(e) { console.log(e); })
    ))
    .pipe($.if(!PRODUCTION, $.sourcemaps.write()))
    .pipe(gulp.dest(PATHS.dist.client + '/assets/js'));
}

// Compile express socket server in coffeescript into javascript
function compileServer() {
  return gulp.src(PATHS.server)
    .pipe(coffee({bare: true}))
    .pipe(rename({ extname: '.js' }))
    .pipe(gulp.dest(PATHS.dist.server));
}

// Copy images to the "dist" folder
// In production, the images are compressed
function images() {
  return gulp.src('src/assets/img/**/*')
    .pipe($.if(PRODUCTION, $.imagemin({
      progressive: true
    })))
    .pipe(gulp.dest(PATHS.dist.client + '/assets/img'));
}

// Start a game server with express and socket.io
function server(done) {
  game.stop();
  game.start();
  done();
}

// and start browser sync
function browserInit(done) {
  browser.init({ proxy: "http://localhost:" + PORT });
  done();
}

// reload the browser
function reload(done) {
  browser.reload();
  done();
}

// Watch for changes to static assets, pages, Sass, JavaScript, and CoffeeScript
function watch() {
  gulp.watch(PATHS.assets, copy);
  gulp.watch('src/pages/**/*.html').on('all', gulp.series(pages, reload));
  gulp.watch('src/layouts/**/*.html').on('all', gulp.series(resetPages, pages, reload));
  gulp.watch('src/assets/scss/**/*.scss').on('all', gulp.series(sass, reload));
  gulp.watch('src/assets/js/**/*.js').on('all', gulp.series(javascript, reload));
  gulp.watch('src/assets/img/**/*').on('all', gulp.series(images, reload));
  gulp.watch('src/react/**/*.coffee').on('all', gulp.series(compileReact, reload));
  gulp.watch('src/server/**/*.coffee').on('all', gulp.series(compileServer, server, reload));
}
