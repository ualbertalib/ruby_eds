require 'rest-open-uri'
require 'nokogiri'
require './config_module'

# This module is based on Nitin Arora's Python binding for the EDS API.
# It provides the same interface, allowing users to:
#  - authenticate with a username and password (or by IP)
#  - open and close a session
#  - perform a search (specifying JSON or XML return type)
#  - pretty print the JSON or XML results
# Sam Popowich, Sam.Popowich@ualberta.ca

module RubyEDS

  def authenticate_user(user_id, password)
  end

  def open_session(profile, guest, org)
  end

  def close_session
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
