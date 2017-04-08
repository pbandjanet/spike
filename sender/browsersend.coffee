async = require 'async'
request = require 'browser-request'

ASYNC_LIMIT = 10

emailAllCompanies = (requestArguments, callback) ->
  async.eachLimit requestArguments, ASYNC_LIMIT, request, callback

