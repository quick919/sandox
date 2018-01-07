require '../my_app'
require 'minitest/autorun'
require 'rack/test'

class MyAppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_my_default
    get '/'
    assert last_response.ok?
  end

  def test_form
    post '/form', {form: 'testあいう嗚呼'}
    assert_equal '"testあいう嗚呼"', last_response.body
  end
end