module Gpx2Obj
  class ObjWriter
    attr_reader :car, :vertices, :faces

    def initialize(car, vertices, faces)
      @car = car
      @vertices = vertices
      @faces = faces
    end

    def content
      "\ng\n#{vertices_content}\n#{faces_content}"
    end

    def write(file_name)
      File.write(file_name, content)
    end

    private

    def faces_content
      "g car\nusemtl white\n".tap do |content|
        # faces.values.map do |face|
        #   next unless face[:PtsList]
        #   content << "f #{face[:PtsList].map(&:abs).join(" ")}\n"
        # end
        vertices.each_with_index do |point, i|
          content << "f #{i} #{i} #{i}\n"
        end
        content << "# #{faces.count} elements"
      end
    end

    def vertices_content
      "".tap do |content|
        vertices.each_with_index do |point, i|
          content << "v #{point.x.to_f * 0.1} #{point.y.to_f * 0.1} #{point.z.to_f * 0.1}\n"
        end
        content << "# #{vertices.count} vertices\n\n"
      end
    end
  end
end
