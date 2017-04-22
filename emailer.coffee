async = require 'async'
companyNames = require('sender').companyNames
emailerData = require 'emailerdata.json'
mailgunKey = require 'mailgunkey.json'

apiKey = mailgunKey["secretKey"]

mailgun = require('mailgun-js')({apiKey})

module.exports.sendEmail =
sendEmail = (data, callback) ->
  if not callback?
    callback = () ->

  mailgun.send(data, callback)

confirmationText = ({fname, companies, body}) ->
  readableCompanies = companies.map (company) ->
    companyNames[company]

  companyString = readableCompanies.join('\n')

  baseText =
    '''
    Hello #{fname}!
    Thanks for speaking out for educated food sources! We've contacted the following companies on your behalf:
    #{companyString}

    Using the following template:
    #{body}

    Have a wonderful day!
    '''

  return baseText

module.exports.sendConfirmation =
sendConfirmation = (data, callback) ->
  {
    fname
    email
    companies
    body
    emailUpdates
  } = data

  {
    confirmationSender
    confirmationSubject
  } = emailerData

  emailData =
    {
      from: confirmationSender
      to: email
      subject: confirmationSubject
      text: confirmationText({fname, companies, body})
    }

  sendEmail(emailData, callback)

feedbackText = ({name, email, subject, message}) ->
  '''
  Feedback from: Name: #{name}, Email: #{email}:
  Subject: #{subject}
  Message:
  #{message}
  '''


module.exports.sendFeedback =
sendFeedback = (data, callback) ->
  if not callback?
    callback = () ->

  {
    name
    email
    subject
    message
  } = data

  {
    feedbackSender
    feedbackReceivers
    sendbackSubject
  } = emailerData

  emailDatas = feedbackReceivers.map (feedbackReceiver) ->
    {
      from: feedbackSender
      to: feedbackReceiver
      subject: feebackSubject
      text: feedbackText(data)
    }
  async.eachLimit emailDatas, 10, sendEmail, callback