Schema = MGS.Schema
sch = new Schema({
  name : { type: String, 'default': ""}
  desc : { type: String, 'default': ""}
#  path : { type: String, 'default': "/public"}
  created_at : { type: Date, 'default': new Date()}

});
### ============================== static methods ============================== ###
sch.statics.getAll = (user_ids, cb) ->

### ============================== instance methods ============================== ###
sch.methods.isWhat= (currency, cb) ->

# db & mongoose is global
TImage = DB_CLIENT.model('TImage', sch);
module.exports = TImage