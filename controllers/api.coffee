SELF = () ->
  return module.exports

module.exports = {
  tastiesSearch:(q, coord, cb) ->
    query = {}
    if q.tags? and q.tags
      query.tags = { $in: q.tags }

    Tasty.find(query).populate('image').exec (err, results) ->
      cb(err, results)
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