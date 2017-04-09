_ = require 'lodash'
bodyParser = require 'body-parser'
express = require 'express'
multer = require 'multer'
sender = require './sender/sender'
#companyForms = require './sender/companyForms.json'

app = express()

app.set 'port', (process.env.PORT || 5000)
app.use express.static(__dirname + '/views')

app.set 'views', (__dirname + '/views')
app.set 'view engine', 'ejs'

app.use bodyParser.json()
app.use bodyParser.urlencoded {extended: true}
app.use multer().none()

{companyNames, companyKeys} = sender


app.get '/', (req, res) ->
  locals = {
    companyNames
    companyKeys
    }
  res.render 'index', {locals}

app.post '/submitContact', (req, res) ->
  console.log 'got submitcontact!'
  console.log "sendContact query: ", req.body
  {
    fname
    lname
    email
    address
    city
    state
    zip
    body
    subject
    companies
    } = req.body

  if companies?
    companies = [companies] unless _.isArray companies

    fullName = fname + ' ' + lname
    messageInfo =
      {
        fullName
        fname
        lname
        email
        address
        city
        state
        zip
        subject
        body
      }

    requestArguments = sender.emailCompanyList companies, messageInfo
    console.log "requestArgs: ",requestArguments
    res.json(requestArguments)
  else
    res.redirect '/'

app.get '/send', (req, res) ->

  {
    fname
    lname
    email
    address
    city
    state
    zip
    body
    subject
    companies
    } = req.query

  companies = [companies] unless _.isArray companies

  fullName = fname + ' ' + lname
  messageInfo =
    {
      fullName
      fname
      lname
      email
      address
      city
      state
      zip
      subject
      body
    }

  sender.emailCompanyList companies, messageInfo, (err) ->
    if err
      console.log "error: ", err

  res.redirect '/'


#testing endpoint
app.post '/test_contact', (req, res) ->
  console.log "hit the test endpoint!"
  console.log req.body
  console.log "posted"
  res.redirect '/'

app.get '/test_contact', (req, res) ->
  console.log "hit the test endpoint!"
  console.log req.query
  console.log "got"
  res.redirect '/'

app.listen app.get('port'), () ->
  console.log 'Node app is running on port', app.get('port')