require 'rest-open-uri'
require 'nokogiri'
require 'rest-client'
require 'json'

module RubyEDS

  def authenticate_user(username, password)
    auth_json = {"UserId"=>"#{username}","Password"=>"#{password}","InterfaceId"=>"WSapi"}.to_json
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
  
  def get_info(session_token, auth_token, return_type="xml")
    response = RestClient.get "http://eds-api.ebscohost.com/edsapi/rest/info", "x-authenticationToken"=>auth_token, "x-sessionToken"=>session_token, :accept=>return_type
  end

  def basic_search(query, session_token, auth_token, view='brief', offset=1, limit=10, order='relevance', return_type="xml")
    response = RestClient.get "http://eds-api.ebscohost.com/edsapi/rest/Search", {:params=>{"query-1"=>query}, "x-authenticationToken"=>auth_token, "x-sessionToken"=>session_token, :accept=>return_type}
  end

  def advanced_search(search_json, return_type="xml")
  end
 
end
