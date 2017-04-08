express = require 'express'
_ = require 'lodash'
sender = require './sender/sender'
companyForms = require './sender/companyForms.json'

app = express()

app.set 'port', (process.env.PORT || 5000)
app.use express.static(__dirname + '/views')

app.set 'views', (__dirname + '/views')
app.set 'view engine', 'ejs'


companyNames = _.mapValues companyForms, (companyForm) -> companyForm.name

app.get '/', (req, res) ->
  res.render 'index', {companyNames}

app.get '/send', (req, res) ->
  console.log req.query

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
  idInfo = {fullName, fname, lname, email, address, city, state, zip}
  messageInfo = {subject, body}

  sender.emailCompanyList companies, messageInfo, idInfo, (err) ->
    if err
      console.log "error: ", err

  res.redirect '/'


#testing endpoint
app.post '/test_contact', (req, res) ->
  console.log "hit the test endpoint!"
  console.log req.query
  console.log "posted"
  res.redirect '/'

app.get '/test_contact', (req, res) ->
  console.log "hit the test endpoint!"
  console.log req.query
  console.log "got"
  res.redirect '/'

app.listen app.get('port'), () ->
  console.log 'Node app is running on port', app.get('port')