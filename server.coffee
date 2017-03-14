express = require 'express'
_ = require 'lodash'
sender = require './sender/sender'
companyForms = require './sender/companyForms.json'

app = express()

app.set 'port', (process.env.PORT || 5000)
app.use express.static(__dirname + '/public')

app.set 'views', (__dirname + '/views')
app.set 'view engine', 'ejs'


companyNames = _.mapValues companyForms, (companyForm) -> companyForm.name

app.get '/', (req, res) ->
  res.render 'index', {companyNames}

app.get '/send', (req, res) ->
  console.log req.query
  res.redirect '/'

app.listen app.get('port'), () ->
  console.log 'Node app is running on port', app.get('port')