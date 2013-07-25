require '../lib/RubyEDS.rb'
require '../lib/config_module.rb'
require 'pp'

include RubyEDS
include ConfigModule

args = get_vars('../lib/util.conf')
username = args['username']
password = args['password']
profile = args['profile']
guest = args['guest']

# authenticate and retrieve authentication token
auth_token = authenticate_user(username, password)
puts auth_token

# create session and retrieve session token
session_token = open_session(profile, guest, auth_token)
puts session_token

# get and information about your search session (XML)
info = get_info(session_token, auth_token)
pp info

# perform basic search and print the results (XML)
hits = basic_search("global warming", session_token, auth_token)
pp hits

# Retrieve and display number of results
doc = Nokogiri::XML(hits)
doc.remove_namespaces!
puts "Number of Results: #{doc.xpath("//TotalHits").inner_text}"

# end session
result = close_session(session_token, auth_token)
if result == "y" then 
  puts "Session closed."
else
  puts "Session not closed."
end


