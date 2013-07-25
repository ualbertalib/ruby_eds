require 'rest-open-uri'
require 'rest-client'
require 'nokogiri'
require './config_module'

include ConfigModule
args = get_vars('../util.conf')
username = args['username']
password = args['password']

# authenticate
auth_json = "{\"UserId\":\"#{username}\",\"Password\":\"#{password}\",\"InterfaceId\":\"WSapi\"}"
response = open('https://eds-api.ebscohost.com/authservice/rest/UIDAuth', :method=>:post, :body => auth_json, 'Content-Type' => 'application/json')
#puts response.read
doc = Nokogiri::XML(response.read)
doc.remove_namespaces!
auth_token = doc.xpath("//AuthToken").inner_text
puts auth_token

# create session
response = RestClient.get "http://eds-api.ebscohost.com/edsapi/rest/CreateSession", {:params=>{"profile"=>"api2", "guest"=>"n"}, :content_type=>:json, "x-authenticationToken"=>auth_token}
doc = Nokogiri::XML(response)
doc.remove_namespaces!
session_token = doc.xpath("//SessionToken").inner_text
puts session_token

# end session
response = RestClient.get "http://eds-api.ebscohost.com/edsapi/rest/endsession", {:params=>{"sessiontoken"=>session_token}, :content_type=>:json, "x-authenticationToken"=>auth_token, "x-sessionToken"=>session_token}
doc = Nokogiri::XML(response)
doc.remove_namespaces!
success = doc.xpath("//IsSuccessful").inner_text
puts "Success? #{success}"


