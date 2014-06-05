api = require('./api')

express = require('express')
router = express.Router()


#requestLogger = middlewares.requestLogger


router.post '/1/tasties',  (req, res) ->
  name = req.param('name');
  desc = req.param('desc');
  tags = req.param('tags');
  pos  = req.param('pos');
  console.log pos

  unless pos
    res.send 404
    return
  api.tastyCreate name, desc, tags, pos, (err, result) ->
    if err
      console.log err
      return res.send 500
    res.send 200, JSON.stringify(result)

router.get '/1/tasties', (req, res) ->
  api.tasties (err, results)->
    if err
      return res.send 500
    res.send 200, JSON.stringify(results);


router.all "*", (req, res) ->
  res.send 404, "API Not Found!"




module.exports = router
