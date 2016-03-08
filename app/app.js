var express = require('express');
var path = require('path');
var logger = require('morgan');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
var multer = require('multer');

var http = require('http');

var app = express();

// multer setput
var storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, './uploads/')
  },
  filename: function (req, file, cb) {
    cb(null, file.fieldname + '-' + Date.now() + '.jpg')
  }
})
app.use(multer({storage: storage}).single('cook'));

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'ejs');

app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

// Port
var port = normalizePort(process.env.PORT || '3000');
app.set('port', port);

// Create Server
var server = http.createServer(app);
server.listen(port);


// Routing and Message
var exec = require('child_process').exec;
var io = require('socket.io')(server);

app.route('/')
  .get(function(req, res) {
    res.render('index', {});
  })
  .post(function(req, res, next) {
    console.log(req.file);
    res.sendStatus(200);
    io.emit('log', { message: 'アップロード完了' });

    cook_categorize(req.file.path)
      .then(poem_generate);
  });

function cook_categorize(path) {
  return new Promise(function(resolve) {
    io.emit('log', { message: '分類中…' });
    console.log(path);
    exec('python ./scripts/dummy01.py', function(err, stdout, stderr){
      io.emit('category', { message: 'カテゴリ：' + stdout });
      resolve(stdout);
    });
  });
}

function poem_generate(category) {
  return new Promise(function(resolve) {
    io.emit('log', { message: 'ポエム生成中…' });
    exec('python ./scripts/dummy02.py ' + category, function(err, stdout, stderr){
      io.emit('poem', { message: stdout });
      resolve(stdout);
    });
  });
}


// Util
function normalizePort(val) {
  var port = parseInt(val, 10);
  if (isNaN(port)) {
    // named pipe
    return val;
  }
  if (port >= 0) {
    // port number
    return port;
  }
  return false;
}