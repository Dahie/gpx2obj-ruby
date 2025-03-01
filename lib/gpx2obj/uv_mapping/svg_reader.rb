require "nokogiri"

module Gpx2Obj
  module UvMapping
    class SvgReader < BaseReader
      private

      def svg
        @svg ||= Nokogiri::XML(File.open(file_path))
      end

      def groups
        [].tap do |groups|
          svg.css("g").each_with_index do |group, index|
            group_id = group["serif:id"] || group["id"] || "group_#{index + 1}"
            faces = {}.tap do |faces|
              group.css("path").each do |path|
                face_id = (path["serif:id"] || path["id"].delete("_")).to_i

                uv = path["d"].scan(/(\d+)[ ,]+(\d+)/).map { |uv| uv.map(&:to_i) }
                faces[face_id.to_i] = {"count" => uv.count, "uv" => uv}
              end
            end
            groups << {
              "title" => group_id,
              "faces" => faces
            }
          end
        end
      end

      def faces
        @faces ||= groups.collect { |g| g["faces"] }.flatten[1..].inject(:merge)
      end

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
