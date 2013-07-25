RubyEDS
=======

Ruby wrapper for the EDS API.

This module is based on Nitin Arora's Python binding for the EDS API.
It provides more or less the same interface, allowing users to:
 - authenticate with a username and password
 - open and close a session
 - perform a search (specifying JSON or XML return type)
 - pretty print the JSON or XML results

There are, however a few changes:
 - I removed the authenticate_with_file method, as you can use a config to provide credentials anyway (see examples)
  - I allowed for both XML and JSON return types (with the default being XML).

As with Nitin's PyEDS, there are a few things left to do:
 - add more options to basicSearch() like "facets", "search mode", "fulltext", "thesaurus", etc.
 - consider adding an authenticateIP() function that uses the IP authentication method.
 - deal with expired tokens, etc.
 - change argument lists to argument hashes to conform to ruby style.

Sam Popowich, Sam.Popowich@ualberta.ca

Eventually, the plan will be for this to integrate directly into the Blacklight/EDS project.

Not checked into this repository is a util.conf file that contains our EDS authentication credentials.
