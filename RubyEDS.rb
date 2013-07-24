require 'rest-open-uri'

module RubyEDS

  def authenticate_user(user_id, password)
    auth_json= '{"UserId":"#{user_id","Password":"#{password}","InterfaceId":"WSapi"}'
    url = "https://eds-api.ebscohost.com/authservice/rest/ipauth"
    headers = "{'Content-Type':'application/json'}"

    response = open(url, :method=>:post:, 
