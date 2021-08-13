require_relative 'setup_tests'
require_relative '../lib/classes/route'

class RouteTest < Test
  def test_initialize
    route = Route.new('index', 'Home', '/index', 'text/html')
    assert_equal('index', route.name)
    assert_equal('Home', route.title)
    assert_equal('/index', route.path)
    assert_equal('text/html', route.content_type)
  end
end
