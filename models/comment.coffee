Schema = MGS.Schema
sch = new Schema({
  author : { type: Schema.ObjectId, ref : "User", index: true , required: true }
  discussion_id : { type: Schema.ObjectId, index: true, required: true } # tasty id

  image_url: { type: String, 'default': null }
  title : { type: String, required:true }
  desc : { type: String, required:true }


  created_at : { type: Date, 'default': new Date()}

});
### ============================== static methods ============================== ###
sch.statics.getAll = (user_ids, cb) ->

  ### ============================== instance methods ============================== ###
sch.methods.isWhat= (currency, cb) ->

# db & mongoose is global
Comment = DB_CLIENT.model('Comment', sch);
module.exports = Comment