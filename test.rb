require 'rest-open-uri'
require 'nokogiri'
require './config_module'

include ConfigModule
args = get_vars('util.conf')
username = args['username']
password = args['password']

auth_json = "{\"UserId\":\"#{username}\",\"Password\":\"#{password}\",\"InterfaceId\":\"WSapi\"}"
response = open('https://eds-api.ebscohost.com/authservice/rest/UIDAuth', :method=>:post, :body => auth_json, 'Content-Type' => 'application/json')
puts response.read
#doc = Nokogiri::XML(response.read)
#doc.remove_namespaces!
#auth_token = doc.xpath("//AuthToken").inner_text
#puts auth_token
#session_info = open("http://eds-api.ebscohost.com/edsapi/rest/createsession?WSapi", :method=>:get, "x-authenticationToken"=>auth_token)
#puts session_info

