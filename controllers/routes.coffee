api = require('./api')

express = require('express')
router = express.Router()

# create uid
mongoose = require('mongoose');
id = mongoose.Types.ObjectId();


#requestLogger = middlewares.requestLogger

mongoose = require('mongoose');
path = require('path');
fs = require('fs');
#uuid = require('node-uuid');

imageService = (req,res) ->
  uploadedImage = req.files.imageField;
  tempPath = uploadedImage.path;
  fs.readFile tempPath, (err, imageData) ->
    imageName = uploadedImage.name;
    if (!imageName) then console.log("There was an error");
    else
      newPath = mongoose.Types.ObjectId(); #Save it with a newName
      contentType = uploadedImage.headers["content-type"];
      fs.writeFile newPath, uploadedImage, (err) ->
        if (err) then console.log("Unable to writeFile:" + err);
        newImageData = {
          filePath: newPath,
          mimeType: contentType,
          assetType: imageAssetType
        }

        #//Save the image information in some database
        #// imageModel contains schema model for the collection
        #
        #//open db connection and handle accordingly
        newImage = new TImage(newImageData);
        newImage.save (err) ->
          if (err) then console.log(err)

getExtension = (filename) ->
  ext = path.extname(filename||'').split('.');
  return ext[ext.length - 1];



router.post '/1/tasty-image', (req, res) ->
  # get the temporary location of the file
#  console.log req.files
#  for key, val in req.files

  tmp_path = req.files.image__.path
  # set where the file should actually exists - in this case it is in the "images" directory

  # move the file from the temporary location to the intended location
  objectId = mongoose.Types.ObjectId()
  objectIdStr = objectId.toString()
  fileExtension = getExtension(req.files.image__.name)
  fileName = objectIdStr + "." + fileExtension
  image = new TImage({_id:objectId, name:fileName})
  image.save (err, result) ->
    if (err) then throw err;
    target_path = './public/tasty_images/' + fileName;
    fs.rename tmp_path, target_path, (err) ->
      if (err) then throw err;
#      res_obj = {
#        image_name : fileName,
#        image_id   : result._id
#      }
      res_obj = result
      #console.log('File uploaded to: ' + target_path + ' - ' + req.files.image__.size + ' bytes');
      res.send JSON.stringify(res_obj);

  # delete file but not exits because moved file.
#  fs.unlink tmp_path, (err) ->
#    if (err) then throw err;


router.post '/1/tasties-image', (req, res) ->


router.post '/1/tasties',  (req, res) ->
  name = req.param('name');
  desc = req.param('desc');
  tags = req.param('tags');
  pos  = req.param('pos');
  img  = req.param('image');
  console.log pos

  unless pos
    res.send 404
    return
  api.tastyCreate name, desc, tags, pos, img, (err, result) ->
    if err
      console.log err
      return res.send 500
    res.send 200, JSON.stringify(result, null, 4)

router.get '/1/tasties', (req, res) ->
  q = req.param('q', null)
  tags = req.param('tags', null)
  coord = req.param('coord', null)
  if tags?
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
