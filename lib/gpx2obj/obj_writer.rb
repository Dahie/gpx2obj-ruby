class Gpx2Obj::ObjWriter
  attr_reader :car, :points, :faces

  def initialize(car, points, faces)
    @car = car
    @points = points
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
      final_points.each_with_index do |point, i|
        content << "f #{i} #{i} #{i}\n"
      end
      content << "# #{faces.count} elements"
    end
  end

  def vertices_content
    "".tap do |content|
      final_points.each_with_index do |point, i|
        content << "v #{point.x.to_f * 0.1} #{point.y.to_f * 0.1} #{point.z.to_f * 0.1}\n"
      end
      content << "# #{final_points.count} vertices\n\n"
    end
  end
end
