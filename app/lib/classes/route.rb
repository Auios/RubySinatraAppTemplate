require_relative '../library'

class Route
  include FromHash
  attr_accessor :name
  attr_accessor :title
  attr_accessor :path
  attr_accessor :content_type

  def initialize(name, title, path, content_type)
    @name = name
    @title = title
    @path = path
    @content_type = content_type
  end
end
