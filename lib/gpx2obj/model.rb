module Gpx2Obj
  class Model
    attr_reader :car, :vertices, :faces, :texture_coordinates, :texture_index

    def initialize(car:, vertices:, faces:, texture_coordinates:, texture_index:)
      @car = car
      @vertices = vertices
      @faces = faces
      @texture_coordinates = texture_coordinates
      @texture_index = texture_index

      # write_debug
    end

    def edges
      car.vertices
    end

    def vertex_ids_per_face(face)
      vertices = Array.new(face[:edgeList].count) do |index|
        #puts index
        edge_id = face[:edgeList][index]
        #puts edge_id

        next if edge_id > 32000 # TODO hacky

        edge = edges[edge_id.abs]

        if edge_id.positive?
          from_id = edge.from+1
          to_id = edge.to+1
        else
          from_id = edge.to+1
          to_id = edge.from+1
        end

        [from_id, to_id]
      end.flatten.compact.uniq

      if uv_indices = texture_index[face[:numl]]
        vertices = Array.new(vertices.count) do |index|
          vertex_id = vertices[index]
          vt_id = uv_indices[index]
          "#{vertex_id}/#{vt_id}"
        end
      end

      return vertices
    end

    def write_debug
      File.write("./out/scales.csv", car.scales.map(&:inspect).join("\n"))
      File.write("./out/edges.csv", car.vertices.map(&:inspect).join("\n"))
      File.write("./out/points.csv", car.points.map(&:inspect).join("\n"))
      File.write("./out/vertices_m1.csv", car.vertices.map(&:inspect).join("\n"))
    end

    def write(file_path, writer)
      File.write(file_path, writer.new(self).content)
    end
  end
end
