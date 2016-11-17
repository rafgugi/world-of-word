'use strict';

import plugins    from 'gulp-load-plugins';
import yargs      from 'yargs';
import browser    from 'browser-sync';
import gulp       from 'gulp';
import panini     from 'panini';
import rimraf     from 'rimraf';
import yaml       from 'js-yaml';
import fs         from 'fs';
import coffee     from 'gulp-coffee';
import browserify from 'gulp-browserify';
import concat     from 'gulp-concat';
import rename     from 'gulp-rename';
import gls        from 'gulp-live-server';
import recursifs  from 'fs-readdir-recursive';

// Load all Gulp plugins into one variable
const $ = plugins();

// Check for --production flag
const PRODUCTION = !!(yargs.argv.production);

// Load settings from settings.yml
const { COMPATIBILITY, PORT, UNCSS_OPTIONS, PATHS } = loadConfig();

function loadConfig() {
  let ymlFile = fs.readFileSync('config.yml', 'utf8');
  return yaml.load(ymlFile);
}

// Build the "dist" folder by running all of the below tasks
gulp.task('build',
 gulp.series(clean, gulp.parallel(pages, sass, javascript, compileReact, compileServer, images, copy)));

// Build the site, run the server, and watch for file changes
gulp.task('default',
  gulp.series('build', gulp.parallel(client, server), watch));

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
    // Comment in the pipe below to run UnCSS in production
    //.pipe($.if(PRODUCTION, $.uncss(UNCSS_OPTIONS)))
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
    .pipe($.babel())
    .pipe($.concat('app.js'))
    .pipe($.if(PRODUCTION, $.uglify()
      .on('error', e => { console.log(e); })
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
      .on('error', e => { console.log(e); })
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

// Start a frontend server with BrowserSync to preview the site in
function client(done) {
  browser.init({
    server: PATHS.dist.client, port: PORT.client
  });
  done();
}

// Start a game server with express and socket.io
function server(done) {
  var game = gls.new(PATHS.dist.server + '/game.js')
  game.start();
  done();
}

// Reload the browser with BrowserSync
function reload(done) {
  browser.reload();
  done();
}

// Watch for changes to static assets, pages, Sass, JavaScript, and CoffeeScript
function watch() {
  gulp.watch(PATHS.assets, copy);
  gulp.watch('src/pages/**/*.html').on('all', gulp.series(pages, browser.reload));
  gulp.watch('src/layouts/**/*.html').on('all', gulp.series(resetPages, pages, browser.reload));
  gulp.watch('src/assets/scss/**/*.scss').on('all', gulp.series(sass, browser.reload));
  gulp.watch('src/assets/js/**/*.js').on('all', gulp.series(javascript, browser.reload));
  gulp.watch('src/assets/img/**/*').on('all', gulp.series(images, browser.reload));
  gulp.watch('src/react/**/*.coffee').on('all', gulp.series(compileReact, browser.reload));
  gulp.watch('src/server/**/*.coffee').on('all', gulp.series(compileServer, server));
}
