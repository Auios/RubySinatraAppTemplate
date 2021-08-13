require 'sinatra/base'
require 'puma'
require 'json'

require_relative 'routes'
require_relative '../lib/constants'
require_relative '../lib/managers/database_manager'

class Server < Sinatra::Base
  disable(:show_exceptions)

  # @return [DatabaseManager]
  def database_manager
    settings.database_manager || raise('database_manager is nil!')
  end

  def self.run!(params = nil)
    super(params)
  end

  before do
    # Route log
    now = Time.now.to_i
    log = {
      '_id' => "#{now}_#{request.ip}",
      'ts' => now,
      'readable_ts' => Time.at(now).to_s,
      'ip' => request.ip,
      'name' => nil,
      'path' => request.path
    }

    # Route info
    route = RouteManager.get_route_from_path(request.path)
    if route
      content_type(route.content_type)
      @title = route.title
      log['name'] = route.name
    end

    # Save log
    # database_manager.save(Constants::Tables::ROUTE_LOG, log)
  end

  not_found do
    erb(:'error/404', { layout: false })
  end

  error do
    puts('An error has occurred')
    erb(:'error/error', { layout: false })
  end

  # Views

  get(RouteManager['index']) do
    erb(:index)
  end

  # API/v1/

  get(RouteManager['api']) do
    result = {
      'result' => 'GOOD'
    }
    result.to_json
  end
end
