SELF = () ->
  return module.exports

module.exports = {
  tastiesSearch:(q, tags, coord, cb) ->
    query = {}
#    if tags? and tags
#      query.tags = { $in: JSON.parse(tags) }
    if q? and q
      regex = new RegExp(q, "i");
      query["$or"] = [ { name : regex }, { desc: regex }, { tags : regex } ]#{ $or : [ { name : regex }, { desc: regex }, { tags : regex } ]};
    console.log(query)
    Tasty.find().populate('image').exec (err, results) ->
      cb(err, results)
#    Tasty.textSearch(q).populate('image').exec (err, results) ->
#      cb(err, results)
  tasties: (cb) ->
    Tasty.find({}).populate('image').exec (err, results) ->
      cb(err, results)
  tastyCreate: (name, desc, tags, pos, imageId, cb) ->
    ts = []
    if tags and tags.length > 0
      ts = tags

    params = {name : name, desc: desc, tags : ts, pos: pos }
    if imageId?
      params.image = ToObjectId(imageId)

    Tasty.create params , (err, result) ->
      cb(err, result);

  tastyUpdate: (name, desc, tags, pos, cb) ->

  tastyDelete: (id, cb) ->
}