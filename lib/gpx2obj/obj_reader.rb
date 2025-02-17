module Gpx2Obj
  class ObjReader
    attr_reader :file_path
    attr_accessor :faces, :vertices

    def initialize(file_path)
      @file_path = file_path
    end

    def read
      @faces = []
      @vertices = []
      vertex_count = 0
      File.read(file_path).split("\n").map(&:chomp).each do |line|
        values = line.split(" ")
        
        case line[0]
        when '#'
        when 'v'
          vertex_count += 1
          vertices << Vertex.new(vertex_count, values[1].to_f, values[2].to_f, values[3].to_f)
        when 'f'
          faces << line[2..]
        end
      end
    end

    def statistics
      puts vertices.select{|v| v.y > 0}.count
      puts vertices.select{|v| v.y < 0}.count
    end
  end
end
