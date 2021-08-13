require_relative '../lib/managers/route_manager'

# Pages
path = ''
RouteManager.add_route('index', 'Home', "#{path}/")

# APIs
path = '/api/v1'
RouteManager.add_route('api', 'query', "#{path}/", 'application/json')
