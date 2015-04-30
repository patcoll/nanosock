var path = require('path');
var express = require('express');
var http = require('http');
var logger = require('morgan');

var app = express();
var server = http.createServer(app);
app.use(logger('dev'));

var router = express.Router();
router.use('/', express.static(path.resolve('www')));
app.use('/', router);
server.listen(3334);
