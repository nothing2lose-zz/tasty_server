Schema = MGS.Schema
sch = new Schema({
  social_id : { type: String, required:true }
  social_type : { type: String, required:true } # current support only facebook.

  name : { type: String, required:true }
  photo_url: { type: String, 'default': null }
  created_at : { type: Date, 'default': new Date()}

  device_token : { type: String, 'default': null }
  device_type : { type: String, 'default': null }


});
### ============================== static methods ============================== ###
sch.statics.getAll = (user_ids, cb) ->

  ### ============================== instance methods ============================== ###
sch.methods.isWhat= (currency, cb) ->

# db & mongoose is global
User = DB_CLIENT.model('User', sch);
module.exports = User