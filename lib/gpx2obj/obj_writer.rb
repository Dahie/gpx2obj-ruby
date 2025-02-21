module Gpx2Obj
  class ObjWriter
    attr_reader :model, :vertices, :faces

    def initialize(model)
      @model = model
      @vertices = model.vertices
    end

    def content
      "mtllib model.mtl\n\n#{vertices_content}\n#{texture_content}\n#{faces_content}"
    end

    private

    def faces_content
      "usemtl Textured\n".tap do |content|
        model.faces.each do |id, face|
          next unless face[:edgeList]

          content << "# id #{face[:numl]}\n"
          vs = model.vertex_ids_per_face(face)
          content << "f #{vs.join(" ")}\n"
        end
        content << "# #{model.faces.count} elements\n"
      end
    end

    def texture_content
      "".tap do |content|
        model.texture_coordinates.each do |point|
          content << "vt #{point[0]} #{point[1]}\n"
        end
      end
    end

    def vertices_content
      "".tap do |content|
        model.vertices.each_with_index do |point, i|
          content << "# id #{i}\n"
          content << "v #{point.x.to_f * 0.1} #{point.z.to_f * 0.1} #{point.y.to_f * 0.1}\n"
        end
        content << "# #{vertices.count} vertices\n"
      end
    end
  end
end
