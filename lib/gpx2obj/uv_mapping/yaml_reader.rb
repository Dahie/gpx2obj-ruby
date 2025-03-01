require "yaml"

module Gpx2Obj
  module UvMapping
    class YamlReader < BaseReader
      def groups
        @groups ||= YAML.load_file("assets/texture.cfg.yml")["groups"]
      end

      def faces
        @faces ||= groups.collect { |g| g["faces"] }.flatten[1..].inject(:merge)
      end

      private

      def parse_file(data)
        faces.each do |face_id, face|
          data[face_id] = [].tap do |coordinates|
            face["uv"].each do |uv|
              coordinates << uv
              uv_coordinates << uv
            end
          end
        end
      end
    end
  end
end
