SELF = () ->
  return module.exports

module.exports = {
  tasties: (cb) ->
    Tasty.find {}, (err, results) ->
      cb(err, results)
  tastyCreate: (name, desc, tags, pos, cb) ->
    ts = []
    if tags and tags.length > 0
      ts = tags
    Tasty.create {name : name, desc: desc, tags : ts, pos: pos} , (err, result) ->
      cb(err, result);

  tastyUpdate: (name, desc, tags, pos, cb) ->

  tastyDelete: (id, cb) ->
}