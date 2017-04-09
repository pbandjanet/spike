async = require 'async'
request = require 'request'
_ = require 'lodash'

ASYNC_LIMIT = 10

companySenders = {}

module.exports.emailCompany =
emailCompany = (company, messageInfo, callback) ->
  request companySenders[company].getRequest(messageInfo), callback

module.exports.emailCompanyList =
emailCompanyList = (companyList, messageInfo, callback) ->
  _.map companyList,
    (company) -> companySenders[company].getRequest(messageInfo)

processBody = (companyName, messageInfo) ->
  {body} = messageInfo
  body.replace "{company}", companyName
  messageInfo.body = body
  messageInfo

makeSender = (companyName, getRequest) ->

  {
    companyName
    getRequest: (messageInfo) ->
      {url, method, qs, enc} = getRequest processBody(companyName, messageInfo)
      if method is 'post'
        enc ?= 'application/x-www-form-urlencoded'
        if enc is 'application/x-www-form-urlencoded'
          return {url, method, form: qs}
        if enc is 'multipart/form-data'
          return {url, method, formData: qs}
      return {url, method, qs}

  }

companySenders['floridasnatural'] = makeSender "Florida's Natural",
  (messageInfo) ->
    url = 'http://www.floridasnatural.com/contact-us.php'
    method = 'post'

    name = messageInfo.fullName
    zip = messageInfo.zip
    email = messageInfo.email
    comments = messageInfo.body

    qs = {name, address, city, state, zip, email, comments}

    return {url, method, qs}

companySenders['stonyfield'] = makeSender 'Stonyfield',
  (messageInfo) ->
    url = "http://www.stonyfield.com/contact-us/feedback"
    method = 'post'

    firstname = messageInfo.fname
    lastname = messageInfo.lname
    feedback_comments = messageInfo.body
    street_address = messageInfo.address
    email = messageInfo.email
    city = messageInfo.city
    feedback_state = messageInfo.state
    zip_code = messageInfo.zip

    qs =
      {
        firstname
        lastname
        feedback_comments
        street_address
        email
        city
        feedback_state
      }

    return {url, method, qs}

companySenders['chobani'] = makeSender 'Chobani',
  (messageInfo) ->
    url = "http://care.chobani.com/ics/support/ticketNewProcess.asp"
    method = 'get'

    customerFirstName = messageInfo.fname
    customerLastName = messageInfo.lname
    FIELD_89109_TEXTAREA_varchar = messageInfo.body
    email = messageInfo.email

    randomString = (len) ->
      Math.random().toString(36).replace(/0./g, '').substr(0, len)
    field1 = randomString 8
    field2 = randomString 4
    field3 = randomString 4
    field4 = randomString 4
    field5 = randomString 12
    customerUserName = "#{field}-#{field2}-#{field3}-#{field4}-#{field5}"

    qs =
      {
        customerFirstName
        customerLastName
        customerUserName
        FIELD_89109_TEXTAREA_varchar
        email
      }

    return {url, method, qs}

companySenders['cuties'] = makeSender 'Cuties',
  (messageInfo) ->
    url = "http://cutiescitrus.com/contact/"
    method = 'post'

    input_1 = messageInfo.fname
    input_2 = messageInfo.lname
    input_3 = messageInfo.address
    input_4 = messageInfo.city
    input_5 = messageInfo.state
    input_6 = messageInfo.zip
    input_7 = messageInfo.email
    input_7_2 = messageInfo.email
    input_11 = messageInfo.body

    qs =
      {
        input_1
        input_2
        input_3
        input_4
        input_5
        input_6
        input_7
        input_7_2
        input_11
      }

    return {url, method, qs}

# add age thingy
companySenders['annies'] = makeSender "Annie's",
  (messageInfo) ->
    url = "http://consumercontacts.generalmills.com/ConsolidatedContact.aspx?page=http://www.annies.com"
    method = 'post'

    qs =
      {
        'ctl00$ContentPlaceHolder1$ddlSubject': "Comment::"
        'ctl00$ContentPlaceHolder1$txtComments': messageInfo.body
        'ctl00$ContentPlaceHolder1$ddlAge': 'Over 35'
        'ctl00$ContentPlaceHolder1$txteid': messageInfo.email
      }

    return {url, method, qs}

# age over 18
companySenders["silk"] = makeSender 'Silk',
  (messageInfo) ->
    url = "https://wwcrs.zingstudios.com/silk/form.php"
    method = 'post'

    qs =
      {
        'fname_14': messageInfo.fname
        'lname_14': messageInfo.lname
        'email1_14': messageInfo.email
        'email2_14': messageInfo.email
        'street_14': messageInfo.address
        'city_14': messageInfo.city
        'state_14': messageInfo.state
        'zip_14': messageInfo.zip
        'country_14': '0'
        'comment_14': messageInfo.body
      }

    return {url, method, qs}

companySenders['boomchickapop'] = makeSender 'BoomChickaPop',
  (messageInfo) ->
    url = "https://boomchickapop.com/contact/#wpcf7-f2870-p2628-o1"
    method = 'post'

    qs =
      {
        'your-name': messageInfo.name
        'your-email': messageInfo.email
        'recipient': 'Allergy/Non-GMO/Gluten-Free'
        'your-message': messageInfo.body
      }

    return {url, method, qs}

companySenders['appleandeve'] = makeSender 'Apple and Eve',
  (messageInfo) ->
    url = 'www.appleandeve.com/contact/multipart/form-data'
    method = 'post'

    qs =
      {
        'item_meta[91]': 'All'
        'item_meta[92]': messageInfo.fname
        'item_meta[94]': messageInfo.lname
        'item_meta[102]': messageInfo.zip
        'item_meta[103]': messageInfo.body
        'item_meta[105]': messageInfo.email
        'item_meta[106]': messageInfo.email
      }

    return {url, method, qs}

# check that this will not send spam
companySenders['authenticroyal'] = makeSender 'Authentic Royal',
  (messageInfo) ->
    url = 'www.authenticroyal.com/contact/multipart/form-data'
    method = 'post'

    qs =
      {
        '28312770-aade-49de-ab56-d10e8d379215': messageInfo.fname
        'ef3292e4-4004-44f3-ad3c-060d30e0feaf': messageInfo.lname
        '8e79d0e1-6721-4459-aef9-e1526310eadf': messageInfo.email
        '87ab800f-49be-454d-9030-e948c6cd1f3d': 'Voice a Concern'
        '31c1162f-4bb1-4daa-a529-4645cf11e34a': messageInfo.body
        '86478e03-1ff2-4436-820e-723599661f95': false
      }

    return {url, method, qs}

companySenders['westminstercrackers'] = makeSender 'Westminster Crackers',
  (messageInfo) ->
    url = 'www.westminstercrackers.com/sendform.php'
    method = 'post'

    qs =
      {
        'first_name': messageInfo.fname
        'last_name': messageInfo.lname
        'email': messageInfo.email
        'message': messageInfo.body
      }

    return {url, method, qs}

companySenders['gourmetbasics'] = makeSender 'Gourmet Basics',
  (messageInfo) ->
    url = 'http://www.gourmetbasics.com/umbraco/PliableSender.asmx/sendForm'
    method = 'post'

    qs =
      {
        'Name': messageInfo.name
        'Email': messageInfo.email
        'Message': messageInfo.body
      }

    return {url, method, qs}

companySenders['barkthins'] = makeSender 'Barkthins',
  (messageInfo) ->
    url = 'barkthins.com/contact-us/#wpcf7-f8159-p8156-o1'
    method = 'post'

    qs =
      {
        'your-name': messageInfo.name
        'your-email': messageInfo.email
        'your-subject': messageInfo.subject
        'your-message': messageInfo.body
      }

    return {url, method, qs}

# used id instead of name
companySenders['nishiki'] = makeSender 'Nishiki',
  (messageInfo) ->
    url = 'http://www.jfc.com/api/api.php?api_call=contact_form'
    method = 'post'

    qs =
      {
        'name': messageInfo.name
        'email': messageInfo.email
        'your_comments': messageInfo.body
        'contact_type': 'contact_us'
      }

    return {url, method, qs}


companySenders['bertolli'] = makeSender 'Bertolli',
  (messageInfo) ->
    url = 'www.villabertolli.com/contact-us#wpcf7-f710-p6-o1'
    method = 'post'

    qs =
      {
        'bertolli-email': 'Bertolli Oils &amp; Vinegars'
        'inquiryType': 'Product Concern'
        'email': messageInfo.email
        'firstName': messageInfo.fname
        'lastName': messageInfo.lname
        'address': messageInfo.address
        'locality': messageInfo.city
        'region': messageInfo.state
        'zip': messageInfo.zip
        'Comment': messageInfo.body
      }

    return {url, method, qs}

companySenders['testingget'] = makeSender 'Testing GET',
  (messageInfo) ->
    url = 'http://localhost:5000/test_contact'
    method = 'get'
    qs =
      {
        'fname': messageInfo.fname
        'lname': messageInfo.lname
        'email': messageInfo.email
        'comment': messageInfo.body
      }
    return {url, method, qs}

companySenders['testingpost'] = makeSender 'Testing POST',
  (messageInfo) ->
    url = 'http://localhost:5000/test_contact'
    method = 'post'
    qs =
      {
        'fname': messageInfo.fname
        'lname': messageInfo.lname
        'email': messageInfo.email
        'comment': messageInfo.body
      }
    return {url, method, qs}

module.exports.companyNames = _.mapValues companySenders,
  (value) -> value.companyName

module.exports.companyKeys = _.sortBy _.keys(companySenders),
  (key) -> companySenders[key].companyName
