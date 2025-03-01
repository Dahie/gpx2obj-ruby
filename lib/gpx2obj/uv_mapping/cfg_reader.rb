module Gpx2Obj
  module UvMapping
    class CfgReader < BaseReader
      private

      def parse_file(data)
        File.foreach(file_path) do |line|
          line.chomp!&.strip!

          next if line.empty? || line.start_with?("//")

          parts = line.split(",").map(&:strip).map(&:to_i)
          face_id = parts[0]

          next if [0, 1].include?(face_id) # skip wheels

          data[face_id] = [].tap do |coordinates|
            parts[2..].each_slice(2) do |u, v|
              coordinates << [u, v]
              uv_coordinates << [u, v]
            end
          end
        end
      end
    end
  end
end
