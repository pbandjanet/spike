request = require 'browser-request'

module.exports =
emailAllCompanies = (requestArguments, callback) ->
  called = false
  callbackOnce = (err) ->
    if not called
      called = true
      if callback?
        callback err


  requestArguments.forEach (requestArgument) ->
    request requestArgument, callbackOnce

