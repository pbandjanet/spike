async = require 'async'
request = require 'request'

companyForms = require './companyForms.json'
_ = require 'lodash'

ASYNC_LIMIT = 10

module.exports.emailCompany =
emailCompany = (company, messageInfo, idInfo, callback) ->
  companyForm = companyForms[company]
  {url, method} = companyForm
  {subject, body} = messageInfo
  body = body.replace "{company}", company
  subject = subject.replace "{company}", company
  qs = _.chain idInfo
          .extend {body, subject}
          .mapKeys (value, key) -> companyForm.form[key]
          .pick _.values(companyForm.form)
          .value()
  request {url, method, qs}, callback


module.exports.emailCompanyList =
emailCompanyList = (companies, messageInfo, idInfo, callback) ->
  send = _.partial emailCompany, _, messageInfo, idInfo
  async.eachLimit companies, ASYNC_LIMIT, send, callback
