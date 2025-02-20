module Gpx2Obj
  class Vertex
    attr_reader :id
    attr_accessor :y, :x, :z

    def initialize(id, x, y, z)
      @id = id
      @x = x
      @y = y
      @z = z
    end
  end
end
