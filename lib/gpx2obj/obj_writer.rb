module Gpx2Obj
  class ObjWriter
    attr_reader :model, :vertices, :faces

    def initialize(model)
      @model = model
      @vertices = model.vertices
      @faces = model.faces
    end

    def content
      "mtllib model.mtl\n\n#{vertices_content}\n#{texture_content}\n#{faces_content}"
    end

    private

    def faces_content
      "usemtl Textured\n".tap do |content|
        faces.each do |id, face|
          next unless face[:edgeList]

          content << "# id #{face[:numl]}\n"
          vs = model.vertex_ids_per_face(face)
          content << "f #{vs.join(" ")}\n"
        end
        content << "# #{faces.count} elements\n"
      end
    end

    def vt_lookup
      @vt_lookup ||= []
    end

    def texture_content
      "".tap do |content|
        model.texture_coordinates.each do |point|
          content << "# face {id}\n"
          content << "vt #{point[0]} #{point[1]}\n"
        end
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
