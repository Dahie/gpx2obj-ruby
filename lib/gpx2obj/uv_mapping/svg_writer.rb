require "victor"
require "base64"

module Gpx2Obj
  module UvMapping
    class SvgWriter
      WIREFRAME_WIDTH = 256
      WIREFRAME_HEIGHT = 256

      attr_reader :uv_mapping

      def initialize(uv_mapping)
        @uv_mapping = uv_mapping
        @svg = Victor::SVG.new(:viewBox => "0 0 #{WIREFRAME_WIDTH} #{WIREFRAME_HEIGHT}", "xmlns:xlink" => "http://www.w3.org/1999/xlink").tap do |svg|
          svg.rect x: 0, y: 0, width: WIREFRAME_WIDTH, height: WIREFRAME_HEIGHT, fill: "#84A584"
        end
      end

      def build_svg(background: true, exclusions: [])
        draw_image(@svg, "assets/00-RC-44.png")
        draw_image(@svg, "assets/00-Williams.png")
        draw_image(@svg, "assets/27-Ferrari.png")
        draw_image(@svg, "assets/05-Benetton.png")

        @svg.css[".face"] = {opacity: 0.4}

        uv_mapping.groups.each do |group|
          @svg.g(id: group["title"]) do
            group["faces"].each do |id, face|
              next if exclusions.include?(id)

              draw_path(@svg, id, face["uv"])
            end
          end
        end

        @svg
      end

      private

      def draw_path(svg, id, surface)
        d = [].tap do |d|
          surface.each_with_index do |coordinate, i|
            d << "#{(i == 0) ? "M" : "L"} #{coordinate[0].to_f + 0.5} #{coordinate[1].to_f + 0.5} "
          end
        end
        d << "Z" # adds closing edge back to start

        svg.path d:, fill: random_color_name, id:, class: "face"
      end

      def draw_image(svg, path, hidden = true)
        png_data = png_to_base64(path)
        svg.image :x => 0, :y => 0, :width => WIREFRAME_WIDTH, :height => WIREFRAME_HEIGHT, :class => hidden && "hidden", "xlink:href" => "data:image/png;base64,#{png_data}"
      end

      def random_color_name
        %w[black
          silver
          gray
          white
          maroon
          red
          purple
          fuchsia
          green
          lime
          olive
          yellow
          navy
          blue
          teal
          aqua
          aliceblue
          antiquewhite
          aqua
          aquamarine
          azure
          beige
          bisque
          black
          blanchedalmond
          blue
          blueviolet
          brown
          burlywood
          cadetblue
          chartreuse
          chocolate
          coral
          cornflowerblue
          cornsilk
          crimson
          cyan
          darkblue
          darkcyan
          darkgoldenrod
          darkgray
          darkgreen
          darkgrey
          darkkhaki
          darkmagenta
          darkolivegreen
          darkorange
          darkorchid
          darkred
          darksalmon
          darkseagreen
          darkslateblue
          darkslategray
          darkslategrey
          darkturquoise
          darkviolet
          deeppink
          deepskyblue
          dimgray
          dimgrey
          dodgerblue
          firebrick
          floralwhite
          forestgreen
          fuchsia
          gainsboro
          ghostwhite
          gold
          goldenrod
          gray
          green
          greenyellow
          grey
          honeydew
          hotpink
          indianred
          indigo
          ivory
          khaki
          lavender
          lavenderblush
          lawngreen
          lemonchiffon
          lightblue
          lightcoral
          lightcyan
          lightgoldenrodyellow
          lightgray
          lightgreen
          lightgrey
          lightpink
          lightsalmon
          lightseagreen
          lightskyblue
          lightslategray
          lightslategrey
          lightsteelblue
          lightyellow
          lime
          limegreen
          linen
          magenta
          maroon
          mediumaquamarine
          mediumblue
          mediumorchid
          mediumpurple
          mediumseagreen
          mediumslateblue
          mediumspringgreen
          mediumturquoise
          mediumvioletred
          midnightblue
          mintcream
          mistyrose
          moccasin
          navajowhite
          navy
          oldlace
          olive
          olivedrab
          orange
          orangered
          orchid
          palegoldenrod
          palegreen
          paleturquoise
          palevioletred
          papayawhip
          peachpuff
          peru
          pink
          plum
          powderblue
          purple
          rebeccapurple
          red
          rosybrown
          royalblue
          saddlebrown
          salmon
          sandybrown
          seagreen
          seashell
          sienna
          silver
          skyblue
          slateblue
          slategray
          slategrey
          snow
          springgreen
          steelblue
          tan
          teal
          thistle
          tomato
          turquoise
          violet
          wheat
          white
          whitesmoke
          yellow
          yellowgreen	].sample
      end

      def png_to_base64(file)
        # https://gist.github.com/bkenny/6294133
        data = File.read(file)
        encoded = Base64.encode64(data)
        encoded.delete("\n")
      end
    end
  end
end
