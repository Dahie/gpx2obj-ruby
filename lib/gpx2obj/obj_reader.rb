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
        next unless values

        case line[0]
        when "#"
        when "v"
          vertices << Vertex.new(vertex_count, values[1].to_f, values[2].to_f, values[3].to_f)
          vertex_count += 1
        when "f"
          puts line
          puts values.inspect
          faces << values[1..-1].map(&:to_i)
        end
      end
    end

    def statistics
      puts vertices.select { |v| v.y > 0 }.count
      puts vertices.select { |v| v.y < 0 }.count
      puts faces.inspect
      puts faces.select { |f| puts f if f.map { |ff| vertices[ff] }.compact.empty? }
    end
  end
end
