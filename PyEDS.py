#PyEDS.py

'''
This module provides a basic Python binding to Ebsco's EDS API, allowing one to:
  - authenticate with a UserID and Password,
  - open and close a session,
  - perform a search (results are returned as JSON),
  - pretty print the JSON.
 
Thanks,
Nitin Arora; nitaro74@gmail.com
____________________________________________________________________________________________________
#Usage example:
 
  import PyEDS as eds
  
  eds.authenticateUser('USERID_GOES_HERE', 'PASSWORD_GOES_HERE')
  eds.openSession('PROFILE_GOES_HERE', 'GUEST_GOES_HERE', 'ORG_GOES_HERE')
 
  #eds.authenticateFile() #alternative to using authenticateUser() and openSession()
  #uses values in JSON config file argument(default="config.json")
  
  #sample "config.json" file:
  """
  {
    "EDS_config": {
      "UserId": "USERID_GOES_HERE",
      "Password": "PASSWORD_GOES_HERE",
      "Profile": "PROFILE_GOES_HERE",
      "Guest": "GUEST_GOES_HERE",
      "Org": ORG_GOES_HERE
    }
  }
  """
 
  kittens = eds.advancedSearch('{"SearchCriteria":{"Queries":[{"Term":"kittens"}],"SearchMode":"smart","IncludeFacets":"y","Sort":"relevance"},"RetrievalCriteria":{"View":"brief","ResultsPerPage":10,"PageNumber":1,"Highlight":"y"},"Actions":null}')
  puppies = eds.advancedSearch('{"SearchCriteria":{"Queries":[{"Term":"puppies"}],"SearchMode":"smart","IncludeFacets":"y","Sort":"relevance"},"RetrievalCriteria":{"View":"brief","ResultsPerPage":10,"PageNumber":1,"Highlight":"y"},"Actions":null}')
  cubs = eds.basicSearch('cubs')
  piglets = eds.basicSearch('piglets', view='brief', offset=1, limit=10, order='relevance')
  
  eds.closeSession()
  
  print 'Some search results with the EDS API ...'
  print '\n"kittens" advanced search as original JSON:'
  print kittens
  print '\n"puppies" advanced search as original JSON:'
  print puppies
  print '\n"kittens" advanced search as JSON with indentation and non-ascii escaping:'
  print eds.prettyPrint(kittens)
  print '\n"cubs" and "piglets" basic searches as original JSON:'
  print cubs, piglets
  print '\nGoodbye.'
____________________________________________________________________________________________________
 
TO DO:
  - add more options to basicSearch() like "facets", "search mode", "fulltext", "thesauras", etc.
    - can't hurt! :-]
  - consider adding an authenticateIP() function that uses the IP authentication method.
  - deal with expired tokens, etc.; see: http://edswiki.ebscohost.com/API_Reference_Guide:_Appendix
'''
 
import urllib2
_EDS_ = {}
 
 
def authenticateUser(UserId, Password):
  '''Authenticates user with an EDS UserId and Password.'''
  auth_json = '{"UserId":"%s","Password":"%s","InterfaceId":"WSapi"}' %(UserId, Password)
  req = urllib2.Request(url='https://eds-api.ebscohost.com/authservice/rest/UIDAuth',
                        data=auth_json,
                        headers={'Content-Type':'application/json'})
  req_open = urllib2.urlopen(req)
  req_results = req_open.read()
  
  req_results_dictionary = eval(req_results) #convert JSON to dictionary.
  _EDS_['AuthToken'] = req_results_dictionary['AuthToken']
  _EDS_['AuthTimeout'] = req_results_dictionary['AuthTimeout']
 
 
def openSession(Profile, Guest, Org):
  '''Opens the EDS session with an EDS Profile, the Guest value ("y" or "n"), and the Org nickname.'''
  sessionOpen_json = '{"Profile":"%s","Guest":"%s","Org":"%s"}' %(Profile, Guest, Org)
  req = urllib2.Request(url='http://eds-api.ebscohost.com/edsapi/rest/CreateSession',
                        data=sessionOpen_json,
                        headers={'Content-Type':'application/json',
                        'x-authenticationToken':_EDS_['AuthToken']})
  req_open = urllib2.urlopen(req)
  req_results = req_open.read()
 
  req_results_dictionary = eval(req_results)
  _EDS_['SessionToken'] = req_results_dictionary['SessionToken'].replace('\\/', '/')
 
 
def closeSession():
  '''Closes the EDS sesssion.'''
  sessionClose_json = '{"SessionToken":"%s"}' %(_EDS_['SessionToken'])
  req = urllib2.Request(url='http://eds-api.ebscohost.com//edsapi/rest/EndSession',
                        data=sessionClose_json,
                        headers={'Content-Type':'application/json',
                        'x-authenticationToken':_EDS_['AuthToken']})
  urllib2.urlopen(req)
  
  
def authenticateFile(config_file='config.json'):
  '''Uses values in JSON config file to authenticate *and* open a session.'''
  config = open(config_file, 'r').read()
  config = eval(config)
  config = config['EDS_config']
  authenticateUser(config['UserId'], config['Password'])
  openSession(config['Profile'], config['Guest'], config['Org'])
 
 
def basicSearch(query, view='brief', offset=1, limit=10, order='relevance'):
  '''Returns search results using basic arguments.'''
  search_json = '''{"SearchCriteria":{"Queries":[{"Term":"%s"}],"SearchMode":"smart","IncludeFacets":"n","Sort":"%s"},
                   "RetrievalCriteria":{"View":"%s","ResultsPerPage":%d,"PageNumber":%d,"Highlight":"n"},"Actions":null}
                   ''' %(query, order, view, limit, offset)
  return advancedSearch(search_json)
 
         
def advancedSearch(search_json):
  '''Returns search results using the full EDS search syntax (JSON).'''
  req = urllib2.Request(url='http://eds-api.ebscohost.com/edsapi/rest/Search',
                        data=search_json, headers={'Content-Type':'application/json',
                        'x-authenticationToken':_EDS_['AuthToken'],
                        'x-sessionToken':_EDS_['SessionToken']})
  req_open = urllib2.urlopen(req)
  req_results = req_open.read()
  return req_results
 
 
def prettyPrint(json_string):
  '''Returns a pretty-printed, UTF-8 encoded JSON string with escaped non-ASCII characters.'''
  import json
  dictionary = json.loads(json_string, encoding='utf=8')
  return json.dumps(dictionary, ensure_ascii=True, indent=2, encoding='utf-8')
 
 
#fin
