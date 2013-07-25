require 'rest-open-uri'
require 'nokogiri'
require 'rest-client'

# This module is based on Nitin Arora's Python binding for the EDS API.
# It provides the same interface, allowing users to:
#  - authenticate with a username and password (or by IP)
#  - open and close a session
#  - perform a search (specifying JSON or XML return type)
#  - pretty print the JSON or XML results
# Sam Popowich, Sam.Popowich@ualberta.ca

module RubyEDS

  def authenticate_user(username, password)
    auth_json = "{\"UserId\":\"#{username}\",\"Password\":\"#{password}\",\"InterfaceId\":\"WSapi\"}"
    response = open('https://eds-api.ebscohost.com/authservice/rest/UIDAuth', :method=>:post, :body => auth_json, 'Content-Type' => 'application/json')
    doc = Nokogiri::XML(response.read)
    doc.remove_namespaces!
    auth_token = doc.xpath("//AuthToken").inner_text
  end

  def open_session(profile, guest, auth_token)
    response = RestClient.get "http://eds-api.ebscohost.com/edsapi/rest/CreateSession", {:params=>{"profile"=>profile, "guest"=>guest}, :content_type=>:json, "x-authenticationToken"=>auth_token}
    doc = Nokogiri::XML(response)
    doc.remove_namespaces!
    session_token = doc.xpath("//SessionToken").inner_text
  end

  def close_session(session_token, auth_token)
    response = RestClient.get "http://eds-api.ebscohost.com/edsapi/rest/endsession", {:params=>{"sessiontoken"=>session_token}, :content_type=>:json, "x-authenticationToken"=>auth_token, "x-sessionToken"=>session_token}
    doc = Nokogiri::XML(response)
    doc.remove_namespaces!
    success = doc.xpath("//IsSuccessful").inner_text
  end

  def authenticate_from_file(config_file='config.json')
  end

  def basic_search(query, view='brief', offset=1, limit=10, order='relevance', return_type="json")
  end

  def advanced_search(search_json, return_type="json")
  end
 
  def pretty_print(content) # content can be either XML or JSON
  end

end
