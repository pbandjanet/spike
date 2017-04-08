async = require 'async'
request = require 'browser-request'

ASYNC_LIMIT = 10

module.exports =
emailAllCompanies = (requestArguments, callback) ->
  async.eachLimit requestArguments, ASYNC_LIMIT, request, callback

