module Gpx2Obj
  class Model
    attr_reader :car, :vertices, :faces, :uv_coordinates, :uv_index, :uv_offset

    def initialize(car:, vertices:, faces:, uv_mapping:)
      @car = car
      @vertices = vertices
      @faces = faces
      @uv_coordinates = uv_mapping.uv_coordinates
      @uv_index = uv_mapping.uv_index
      @uv_offset = uv_mapping.uv_offset
    end

    def edges
      car.vertices
    end

    def vertex_ids_per_face(face)
      vertices = Array.new(face[:edgeList].count) do |index|
        edge_id = face[:edgeList][index]

        next if edge_id > 32000 # TODO hacky

        edge = edges[edge_id.abs]

        if edge_id.positive?
          from_id = edge.from + 1
          to_id = edge.to + 1
        else
          from_id = edge.to + 1
          to_id = edge.from + 1
        end

        [from_id, to_id]
      end.flatten.compact.uniq

      if (uv_indices = uv_index[face[:numl]])
        vertices = Array.new(vertices.count) do |index|
          vertex_id = vertices[index]
          vt_id = uv_indices[index]
          "#{vertex_id}/#{vt_id + 1}"
        end
      end

      vertices.reverse
    end

    def write(file_path, writer)
      File.write(file_path, writer.new(self).content)
    end
  end
end
