SELF = () ->
  return module.exports

module.exports = {
  userLogin: (name, social_id, social_type, device_type, device_token, cb) ->
    params = { name: name, social_id: social_id, social_type: social_type, device_type : device_type}
    if device_token?
      params.device_token = device_token

    User.findOne { social_id : social_id, social_type: social_type }, (err, result) ->
      if result and ! err
        return cb(err, result)
      else if ! err and ! result
        console.log "======== user willbe create"
        console.log params
        User.create params, (err, result) ->
          cb(err, result)


  tastiesSearch:(q, tags, coord, cb) ->
    query = {}
#    if tags? and tags
#      query.tags = { $in: JSON.parse(tags) }
    if q? and q
      regex = new RegExp(q, "i");
      query["$or"] = [ { name : regex }, { desc: regex }, { tags : regex } ] #query = { $or : [ { name : regex }, { desc: regex }, { tags : regex } ]};

    Tasty.find(query).populate('images owner').exec (err, results) ->
      cb(err, results)
#    Tasty.textSearch(q).populate('image').exec (err, results) ->
#      cb(err, results)

  tasties: (cb) ->
    Tasty.find({}).populate('images owner').exec (err, results) ->
      cb(err, results)
  tastyCreate: (session, name, desc, tags, pos, imageIds, cb) ->
    ts = []
    if tags and tags.length > 0
      ts = tags
    user_id = ToObjectId(session.user._id)
    params = { owner: user_id, name : name, desc: desc, tags : ts, pos: pos }
    console.log JSON.stringify(session.user, null, 4)
    console.log "============ tasty create!"
    console.log JSON.stringify(params, null, 4)
    if imageIds? and imageIds.length > 0
      images = []
      for key, val of imageIds
        images.push ToObjectId(val)
      if images.length > 0
        params.images = images

    Tasty.create params , (err, result) ->
      cb(err, result);

  tastyUpdate: (id, name, desc, tags, pos, imageId, cb) ->
    condition = { _id : ToObjectId(id) }
    ts = []
    if tags and tags.length > 0
      ts = tags
    params = { name : name, desc: desc, tags : ts, pos: pos }
    if imageId?
      params.image = ToObjectId(imageId)
    console.log condition
    console.log params
    Tasty.findOneAndUpdate condition, params, (err, result) ->
      console.log result
      cb(err, result)

  tastyDelete: (id, cb) ->
}