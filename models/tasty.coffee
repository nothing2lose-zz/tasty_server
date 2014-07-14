Schema = MGS.Schema
sch = new Schema({
  name : { type: String, 'default': "", required:true}
  desc : { type: String, 'default': "", required:true}
  tags : { type: Array, 'default': []}
  updated_at : { type: Date, 'default': new Date()}
  created_at : { type: Date, 'default': new Date()}
#  pos: { type: Schema.Types.Mixed, index: '2dsphere', sparse: true}
  pos : { type: [Number], index: '2d'}
#  pos: { type:{ type: String, required:true }, coordinates: {type :Array, required:true}}
  #image : { type: Schema.ObjectId, ref : "TImage", index: { unique: true, sparse: true } , 'default': null }
  image : { type: Schema.ObjectId, ref : "TImage", index: true , 'default': null }
});

#sch.index({ 'pos.coordinates' : '2dsphere' });

sch.pre 'save',  (next) ->
  @updated_at= new Date()
#  value = @pos
#  if (value is null) then return next();
#  if (value is undefined) then return next();
#  if (!Array.isArray(value)) then return next(new Error('Coordinates must be an array'));
##  if (value.length is 0) then return @set(path, undefined);
#  if (value.length isnt 2) then return next(new Error('Coordinates should be of length 2'))
  next();


#Geo.geoSearch({ type : "place" }, { near : [9,9], maxDistance : 5 }, function (err, results, stats) {
#  console.log(results);
#});

#Geo.geoNear([9,9], { spherical : true, maxDistance : .1 }, function (err, results, stats) {
#console.log(results);
#});

### ============================== static methods ============================== ###
sch.statics.getAll = (user_ids, cb) ->

### ============================== instance methods ============================== ###
sch.methods.isWhat= (currency, cb) ->

# db & mongoose is global
Tasty = DB_CLIENT.model('Tasty', sch);
module.exports = Tasty