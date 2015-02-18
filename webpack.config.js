var extend = require('extend');
var webpack = require('webpack');
var path = require('path');
var production = (process.env.NODE_ENV === 'production');
var dist = production ? 'dist' : 'build';

var common = {
  output: {
    pathinfo: !production,
    library: 'nanosock',
    libraryTarget: 'umd'
  },
  module: {
    loaders: [
      { test: /\.coffee$/, loader: 'coffee' }
    ]
  },
  resolve: {
    root: __dirname,
    modulesDirectories: [
      "bower_components",
      "node_modules"
    ],
    extensions: ["", ".js", ".coffee"]
  }
};

var plugins = function(opts) {
  var options = extend(true, {
    production: false
  }, opts);
  var plugins = [];
  plugins.push(
    new webpack.ResolverPlugin(new webpack.ResolverPlugin.DirectoryDescriptionFilePlugin('bower.json', ['main']))
  );
  if (options.production) {
    plugins.push(new webpack.optimize.UglifyJsPlugin());
    plugins.push(new webpack.optimize.OccurenceOrderPlugin());
  }
  return plugins;
};

module.exports = [
  extend(true, {}, common, {
    name: 'regular',
    target: 'web',
    debug: true,
    devtool: 'source-map',
    entry: path.resolve('src/nanosock.js'),
    output: {
      path: path.resolve(dist),
      filename: 'nanosock.js'
    },
    plugins: plugins({
      production: false
    })
  }),
  extend(true, {}, common, {
    name: 'minified',
    target: 'web',
    entry: path.resolve('src/nanosock.js'),
    output: {
      path: path.resolve(dist),
      filename: 'nanosock.min.js'
    },
    plugins: plugins({
      production: true
    })
  })
];
