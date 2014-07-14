#require 'express-namespace'
express = require('express')
path = require('path')
favicon = require('static-favicon')
logger = require('morgan')
cookieParser = require('cookie-parser')
bodyParser = require('body-parser')
methodOverride = require('method-override')
connectMultipart = require('connect-multiparty')

routes = require('./controllers/routes')

http      = require('http')
fs        = require('fs')

models = require('./models/models')

app = express()

#app.set('json spaces',0)
app.use(favicon());
app.use(logger('dev'));
app.use methodOverride()
app.use connectMultipart()

app.use bodyParser({keepExtensions:true,uploadDir:path.join(__dirname,'/image_files')});
#app.use(bodyParser());
#app.use(bodyParser.urlencoded());
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));


##app.use express.compress()
#app.use favicon()
#app.use bodyParser.json()
#app.use bodyParser.urlencoded()
#app.use cookieParser()
##app.use express.session({secret: '2ijfAKBj23ijfaskdvjl349uasFfkajfi43j43928kjasfALSdj'}) # session base on in-memory
#app.use express.static( __dirname + '/public')

process.on 'uncaughtException', (err) ->
  console.log " ---- BEGIN ### [Uncahught Exception] ### ---- "
  console.log err
  console.log err.stack
  console.log " ---- END ### [Uncahught Exception] ### ---- "
#  sendMail("GameServer", err, err.stack)


app.all('*', routes);
#(require('./controllers/routes'))(app)
#app.use '/', routes

app.listen(8888);

module.exports = app

