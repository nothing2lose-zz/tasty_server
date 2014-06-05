rest = require 'restler'

data = {'gg' : 'vval'}
#data = { 'key' : 'value'}

rest.postJson('http://127.0.0.1:8888/1/tasties/', {data : data }).on 'complete', (data, response) ->
  console.log data