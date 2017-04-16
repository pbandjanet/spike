_ = require 'lodash'
async = require 'async'
bodyParser = require 'body-parser'
express = require 'express'
multer = require 'multer'
sender = require './sender/sender'
pg = require 'pg'

ASYNC_LIMIT = 10

pool = new pg.Pool({database: process.env.DATABASE_URL || 'gmodb'})

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


insertData = (client, tableName, columns, row, callback) ->
  values = (row[column] for column in columns)
  console.log values
  queryStr =
    """
    INSERT INTO #{tableName} (#{columns.join(',')})
    VALUES ($#{[1..values.length].join(', $')})
    """
  console.log queryStr

  client.query(queryStr, values, callback)

insertSendData = (info, companies, callback) ->
  pool.connect (err, client, done) ->
    if err
      console.log "Error Connecting to", err
      return done err
    columns =
      [
        'fname'
        'lname'
        'email'
        'address'
        'city'
        'state'
        'zip'
        'body'
        'subject'
      ]

    rowWithoutCompany = _.pick info, columns
    columns.push('company')


    processCompany = (company, cb) ->
      row = _.clone(rowWithoutCompany)
      row.company = company
      insertData client, 'sent_table', columns, row, cb

    async.eachLimit companies, ASYNC_LIMIT, processCompany, callback



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

    insertSendData messageInfo, companies, (err, result) ->
      if err?
        console.log "Error in Insert! ", err
      console.log "result: ",result

    requestArguments = sender.emailCompanyList companies, messageInfo
  else
    requestArguments = []

  console.log "requestArgs: ",requestArguments
  res.json(requestArguments)

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

  insertSendData messageInfo, companies, (err, result) ->
    if err?
      console.log "Error in Insert! ", err
    console.log "result: ",result

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