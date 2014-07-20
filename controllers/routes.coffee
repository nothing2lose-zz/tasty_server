api = require('./api')

express = require('express')
router = express.Router()

# create uid
mongoose = require('mongoose');
id = mongoose.Types.ObjectId();


#requestLogger = middlewares.requestLogger
# sessionChecker = middlewares.sessionChecker

sessionChecker = (req, res, next) ->
  if req.session.user
    next()
  else
    req.session.error = 'Require Authentication to accesss APIs'
    res.send 401


mongoose = require('mongoose');
path = require('path');
fs = require('fs');
#uuid = require('node-uuid');

#imageService = (req, res) ->
#  uploadedImage = req.files.imageField;
#  tempPath = uploadedImage.path;
#  fs.readFile tempPath, (err, imageData) ->
#    imageName = uploadedImage.name;
#    if (!imageName) then console.log("There was an error");
#    else
#      newPath = mongoose.Types.ObjectId(); #Save it with a newName
#      contentType = uploadedImage.headers["content-type"];
#      fs.writeFile newPath, uploadedImage, (err) ->
#        if (err) then console.log("Unable to writeFile:" + err);
#        newImageData = {
#          filePath: newPath,
#          mimeType: contentType,
#          assetType: imageAssetType
#        }
#
#        #//Save the image information in some database
#        #// imageModel contains schema model for the collection
#        #
#        #//open db connection and handle accordingly
#        newImage = new TImage(newImageData);
#        newImage.save (err) ->
#          if (err) then console.log(err)

router.post '/1/login', (req, res) ->
  # required params
  username = req.param('name', null)
  social_id = req.param('social_id', null)
  social_type = req.param('social_type', null)
  device_type = req.param('device_type', null)
  # optional params
  device_token = req.param('device_token', null)
  api.userLogin username, social_id, social_type, device_type, device_token, (err, result) ->
    if err
      res.send 500, "로그인 실패"
    else
      req.session.user = result
      console.log result
      res.send 200, JSON.stringify(result)


router.post '/1/logout', (req, res) ->
  req.session = null
  res.send 200



getExtension = (filename) ->
  ext = path.extname(filename||'').split('.');
  return ext[ext.length - 1];


saveFile = (file, cb) ->
  objectId = mongoose.Types.ObjectId()
  objectIdStr = objectId.toString()
  fileExtension = getExtension(file.name)
  fileName = objectIdStr + "." + fileExtension
  image = new TImage({_id:objectId, name:fileName})
  image.save (err, result) ->
    if (err) then throw err;
    target_path = './public/tasty_images/' + fileName;
    fs.rename file.path, target_path, (err) ->
      if (err) then throw err;

      cb(err, result)

router.post '/1/tasty-images', sessionChecker, (req, res) ->
  # get the temporary location of the file
#  console.log req.files
#  for key, val in req.files

#  tmp_path = req.files.image__.path
  counter = 0
  results = []
  success = true
  console.log "===================== request accpeted!"
  console.log typeof req.files
#  console.log req.files
#  console.log req.files

  for key, val of req.files
    counter = counter + 1
    file = req.files[key]
    saveFile file, (err, result) ->
      counter = counter - 1
      if (err)
        return success = false
      results.push(result)
      if 0 is counter
        if success
          res.send 200, JSON.stringify(results, null, 4)
        else
          res.send 500


  # set where the file should actually exists - in this case it is in the "images" directory

  # move the file from the temporary location to the intended location
#  objectId = mongoose.Types.ObjectId()
#  objectIdStr = objectId.toString()
#  fileExtension = getExtension(req.files.image__.name)
#  fileName = objectIdStr + "." + fileExtension
#  image = new TImage({_id:objectId, name:fileName})
#  image.save (err, result) ->
#    if (err) then throw err;
#    target_path = './public/tasty_images/' + fileName;
#    fs.rename tmp_path, target_path, (err) ->
#      if (err) then throw err;
#      res_obj = result
#      #console.log('File uploaded to: ' + target_path + ' - ' + req.files.image__.size + ' bytes');
#      res.send JSON.stringify(res_obj);

  # delete file but not exits because moved file.
#  fs.unlink tmp_path, (err) ->
#    if (err) then throw err;


router.post '/1/tasties-image', (req, res) ->


router.post '/1/tasties', sessionChecker,  (req, res) ->
  name = req.param('name');
  desc = req.param('desc');
  tags = req.param('tags');
  pos  = req.param('pos');
  imgs  = req.param('images');
  console.log pos
  console.log imgs

  unless pos
    return res.send 400

  api.tastyCreate req.session, name, desc, tags, pos, imgs, (err, result) ->
    if err
      console.log err
      return res.send 500
    res.send 200, JSON.stringify(result, null, 4)

router.put '/1/tasties', sessionChecker, (req, res) ->
  id = req.param('_id')
  name = req.param('name')
  desc = req.param('desc')
  tags = req.param('tags')
  pos = req.param('pos')
  img = req.param('images', null)
  unless pos
    return res.send 400
  api.tastyUpdate id, name, desc, tags, pos, img, (err, result) ->
    if err
      console.log err
      return res.send 500
    res.send 200, JSON.stringify(result, null, 4)



router.get '/1/tasties', sessionChecker,  (req, res) ->
#  console.log req.session
#  console.log JSON.stringify(req.session, null, 4)
  q = req.param('q', null)
  tags = req.param('tags', null)
  coord = req.param('coord', null)
  if q?
    api.tastiesSearch q, tags, coord, (err, results)->
      if err
        return res.send 500
      res.send 200, JSON.stringify(results, undefined, 4)

  else
    api.tasties (err, results)->
      if err
        return res.send 500
      console.log "============??"
      res.send 200, JSON.stringify(results, undefined, 4)


router.all "*", (req, res) ->
  res.send 404, "API Not Found!"




module.exports = router
