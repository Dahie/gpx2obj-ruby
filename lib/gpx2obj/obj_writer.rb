module Gpx2Obj
  class ObjWriter
    attr_reader :model, :vertices, :faces

    def initialize(model)
      @model = model
      @vertices = model.vertices
      @faces = model.faces
    end

    def content
      "#{vertices_content}\n#{faces_content}"
    end

    private

    def faces_content
      "usemtl white\n".tap do |content|
        faces.each do |id, face|
          next unless face[:edgeList]

          vs = model.vertex_ids_per_face(face)
          # vs.each do |v|
          #   puts vertices[v].inspect
          # end

          content << "# id #{id}\n"
          content << "f #{vs.map { |v| v + 1 }.join(" ")}\n"
        end
        content << "# #{faces.count} elements\n"
      end
    end

    def vertices_content
      "".tap do |content|
        vertices.each_with_index do |point, i|
          content << "# id #{i}\n"
          content << "v #{point.x.to_f * 0.1} #{point.z.to_f * 0.1} #{point.y.to_f * 0.1}\n"
        end
        content << "# #{vertices.count} vertices\n"
      end
    end
  end
end
