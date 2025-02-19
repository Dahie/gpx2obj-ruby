module Gpx2Obj
  class Vertex
    attr_reader :id, :connected
    attr_accessor :y, :x, :z

    def initialize(id, x, y, z)
      @id = id
      @x = x
      @y = y
      @z = z
      @connected = Set.new
    end

    def connect(c_vertex)
      @connected.add(c_vertex.id)
    end
  end
end
