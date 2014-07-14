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


global.Tasty = require './tasty'
global.TImage = require './timage'