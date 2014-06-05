mongoose = require('mongoose')

getDBURI = () ->
  uri = 'mongodb://localhost/tasty';
  if global.IS_TEST_MODE
    uri = uri + '-test'
  return uri

# COMMON GLOBAL VARIABLES. #require('./global_variables') # this file has declared global variables.
global.IS_TEST_MODE = ( process.env.NODE_ENV is 'test' ) # is true when Makefile test
global._            = require('underscore')
global.MGS          = mongoose;
global.DB_CLIENT    = mongoose.createConnection( getDBURI() )

#global.ASYNC        = require('async') # for mongoose

global.ObjectId     = mongoose.Types.ObjectId;
global.ToObjectId   = (obj_id) ->
  if (obj_id instanceof ObjectId)
    return obj_id
  else
    if ObjectId.fromString?
      return ObjectId.fromString(obj_id)
    else if ObjectId.createFromHexString?
      return ObjectId.createFromHexString(obj_id)



Schema = MGS.Schema
sch = new Schema({
  name : { type: String, 'default': ""}
  desc : { type: String, 'default': ""}
  tags : { type: Array, 'default': []}
  updated_at : { type: Date, 'default': new Date()}
  created_at : { type: Date, 'default': new Date()}
  pos: { type: [Number], index: '2d' }

});

#Geo.geoSearch({ type : "place" }, { near : [9,9], maxDistance : 5 }, function (err, results, stats) {
#  console.log(results);
#});

#Geo.geoNear([9,9], { spherical : true, maxDistance : .1 }, function (err, results, stats) {
#console.log(results);
#});

sch.pre 'save', (next)->
  @updated_at= new Date()
  next()

### ============================== static methods ============================== ###
sch.statics.getAll = (user_ids, cb) ->

### ============================== instance methods ============================== ###
sch.methods.isWhat= (currency, cb) ->

# db & mongoose is global
Tasty = DB_CLIENT.model('Tasty', sch);
global.Tasty = Tasty
module.exports = Tasty