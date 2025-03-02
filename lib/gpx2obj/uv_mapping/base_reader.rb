module Gpx2Obj
  module UvMapping
    class BaseReader
      attr_reader :file_path, :uv_coorginates

      def initialize(file_path)
        @file_path = file_path
        @uv_coordinates = []
        texture_coordinates
      end

      def uv_index
        @uv_index ||= {}
      end

      def uv_coordinates
        @uv_coordinates ||= []
      end

      def write_to_yaml
        yaml = groups.to_yaml
        File.write("out/new.yml", yaml)
      end

      def texture_coordinates
        @texture_coordinates ||= {}.tap do |data|
          parse_file(data)

          uv_coordinates.uniq!

          data.each do |face_id, coordinates|
            coordinates.each do |co|
              uv_index[face_id.to_i] = [] unless uv_index[face_id]
              uv_index[face_id.to_i] << uv_coordinates.find_index(co)
            end
          end
        end
      end
    end
  end
end
