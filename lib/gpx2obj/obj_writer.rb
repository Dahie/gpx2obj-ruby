module Gpx2Obj
  class ObjWriter
    attr_reader :model, :vertices, :faces

    def initialize(model)
      @model = model
      @vertices = model.vertices
      @faces = model.faces
    end

    def content
      "g\n#{vertices_content}\n#{faces_content}"
    end

    private


    def vertex_ids_per_face(face)
      puts face.inspect
      face[:edgeList].map do |edge_id|
        edge_id = edge_id.abs
        next if edge_id > 32000
        edge = model.edges[edge_id]
        puts edge.inspect
        [edge.from, edge.to] #.compact
      end.compact.flatten.join(" ")
    end

    def faces_content
      "g car\nusemtl white\n".tap do |content|
        faces.each do |id, face|
          next unless face[:edgeList]
          content << "# id #{id}\n"
          content << "f #{vertex_ids_per_face(face)}\n"
        end
        # vertices.each_with_index do |point, i|
        #   content << "f #{i} #{i} #{i}\n"
        # end
        content << "# #{faces.count} elements\n"
      end
    end

    def vertices_content
      "".tap do |content|
        vertices.each_with_index do |point, i|
          content << "# id #{i}\n"
          content << "v #{point.x.to_f * 0.1} #{point.y.to_f * 0.1} #{point.z.to_f * 0.1}\n"
        end
        content << "# #{vertices.count} vertices\n"
      end
    end
  end
end
