request = require 'request'
companyForms = require './companyForms.json'
_ = require 'lodash'

ASYNC_LIMIT = 10

emailCompany = (company, body, idInfo, callback) ->
  companyForm = companyForm[company]
  {url, method} = companyForm
  body = body.replace "{company}", company
  form = _.chain(idInfo).extend({body}).mapkeys idInfo, companyForm.form
  request {url, method, form}, callback


emailCompanyList = (companies, body, idInfo, callback) ->
  send = _.partial emailCompany, _, body, idInfo
  async.eachLimit companies, ASYNC_LIMIT, send, callback

module.exports = emailCompanyList
