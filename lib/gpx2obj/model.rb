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

      tex_co = texture_coordinates[face[:numl]].inspect
      puts tex_co
      face[:edgeList].each_with_index do |edge_id, index|
        aedge_id = edge_id.abs
        next if edge_id > 32000 # TODO hacky

        edge = edges[aedge_id]

        if edge_id.positive?
          from_id = edge.from
          to_id = edge.to+1
        else
          from_id = edge.to
          to_id = edge.from
        end
        from_uv_id = texture_index[from_id]
        to_uv_id = texture_index[to_id]

        #puts from_uv_id.inspect

        ["#{from_id+1}/#{from_uv_id}", "#{to_id+1}/#{to_uv_id}"]
      end.flatten.compact.uniq
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
