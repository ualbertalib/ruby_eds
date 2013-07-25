require 'test/unit'
require "../lib/RubyEDS.rb"
require "./config_module.rb"

class TestRubyEDS < Test::Unit::TestCase
  include RubyEDS
  include ConfigModule

  def setup
    @args = get_vars('../util.conf')
  end

  def test_authentication_token_is_not_nil
    @auth_token = authenticate_user(@args['username'], @args['password'])
    assert_not_nil @auth_token
  end

  def test_session_token_is_not_nil
    @session_token = open_session(@args['profile'], @args['guest'], @auth_token)
    assert_not_nil @session_token
    close_session @session_token, @auth_token
  end

  def test_close_session_is_successful
    @session_token = open_session(@args['profile'], @args['guest'], @auth_token)
    success = close_session @session_token, @auth_token
    assert_equal "y", success
  end
end
