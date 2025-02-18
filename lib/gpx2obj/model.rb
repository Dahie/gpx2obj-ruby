require "forwardable"

module Gpx2Obj
  class Model
    extend Forwardable

    attr_reader :car, :vertices, :faces

    def initialize(car:, vertices:, faces:)
      @car = car
      @vertices = vertices
      @faces = faces

      write_debug
    end

    def edges
      car.vertices
    end

    def write_debug


      File.write("./out/scales.csv", car.scales.map(&:inspect).join("\n"))
      File.write("./out/edges.csv", car.vertices.map(&:inspect).join("\n"))
      File.write("./out/points.csv", car.points.map(&:inspect).join("\n"))
      File.write("./out/vertices_m1.csv", car.vertices.map(&:inspect).join("\n"))

    end

    def debug
      header = car.header

      header.size8
      num_scale = (header.scale_end - header.scale_begin) / 2
      puts "Scales: #{num_scale}"
      num_points = (header.vertex_begin - header.points_begin) / 8
      num_unks = (header.file_end - header.vertex_end) / 2

      puts "Points: #{num_points}"

      num_vertices = (header.vertex_end - header.vertex_begin) / 4

      puts "vertices: #{num_vertices}"
      puts "Unks: #{num_unks}"

      puts "---"

      puts header.magic.inspect
      puts header.id.inspect
      puts header.scale_begin
      puts header.scale_end
      puts header.texture_begin
      puts header.vertex_begin
      puts header.vertex_end
      puts header.points_begin
      puts header.texture_end

      puts "---"

      puts Gpx2Obj::ShpReader::HEADER_LENGTH + (header.scale_begin - header.scale_begin) # scale begin
      puts Gpx2Obj::ShpReader::HEADER_LENGTH + (header.scale_end - header.scale_begin) # scale end
      puts Gpx2Obj::ShpReader::HEADER_LENGTH + (header.texture_begin - header.scale_begin) # texture begin
      puts Gpx2Obj::ShpReader::HEADER_LENGTH + (header.texture_end - header.scale_begin) # texture end
      puts Gpx2Obj::ShpReader::HEADER_LENGTH + (header.points_begin - header.scale_begin) # points begin
      puts Gpx2Obj::ShpReader::HEADER_LENGTH + (header.vertex_begin - header.scale_begin) # vertex begin
      puts Gpx2Obj::ShpReader::HEADER_LENGTH + (header.vertex_end - header.scale_begin) # vertex end
      # puts Gpx2Obj::ShpReader::HEADER_LENGTH + (header.points_end - header.scale_begin) #points end

      puts header.inspect

      puts "-----"

      # puts car.vertices.count
      # car.vertices.each_with_index do |vertex, i|
      #   puts "vertex #{i} - #{vertex.from}, #{vertex.to}, #{vertex.a}, #{vertex.b}"
      # end
    end

    def write(file_path, writer)
      File.write(file_path, writer.new(self).content)
    end
  end
end
