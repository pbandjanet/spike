express = require 'express'
sender = require './sender/sender'

app = express()

app.set 'port', (process.env.PORT || 5000)
app.use express.static(__dirname + '/public')

app.set 'views', (__dirname + '/views')
app.set 'view engine', 'ejs'

app.get '/', (req, res) ->
  res.render 'index'

app.post '/', (req, res) ->
  {fname, lname, email, address, city, state, zip, emailText} = req.body
  res.render 'index'

app.listen app.get('port'), () ->
  console.log 'Node app is running on port', app.get('port')