module Gpx2Obj
  class ObjWriter
    attr_reader :model, :vertices, :faces

    SCALE = 0.01

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

          content << "# id f #{face[:numl]}\n"
          vs = model.vertex_ids_per_face(face)
          puts vs.inspect
          content << "f #{vs.join(" ")}\n"
        end
        content << "# #{model.faces.count} elements\n"
      end
    end

    def texture_content
      "".tap do |content|
        model.texture_coordinates.each_with_index do |point, index|
          content << "# id vt #{index}\n"
          content << "vt #{point[0] / 256.0} #{point[1] / 256.0}\n"
        end
        content << "# #{model.texture_coordinates.count} elements\n"
      end
    end

    def vertices_content
      "".tap do |content|
        model.vertices.each_with_index do |point, i|
          content << "# id v #{i}\n"
          # we rotate the model along Y acess, otherwise it stands on nose-tip
          content << "v #{point.x.to_f * SCALE} #{point.z.to_f * SCALE} #{point.y.to_f * SCALE}\n"
        end
        content << "# #{vertices.count} elements\n"
      end
    end
  end
end
