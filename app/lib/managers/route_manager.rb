require_relative '../classes/route'

class RouteManager
  class << self
    attr_reader :routes

    def add_route(name, title, path, content_type = 'text/html')
      raise "Route '#{name}' already exists!" unless routes[name].nil?

      all_paths = routes.map { |_, value| value.path }
      raise "Path '#{path}' already exists!" if all_paths.include?(path)

      routes[name] = Route.new(name, title, path, content_type)
    end

    # return [String]
    def self.[](name)
      result = nil
      result = routes[name].path unless routes[name].nil?
      result
    end

    # @return [Route]
    def self.get_route_from_path(path)
      result = nil
      if path
        routes.each do |_, route|
          if route.path == path
            result = route
            break
          end
        end
      end
      result
    end
  end

  @routes = Hash.new(nil)
end
