require "victor"
require "base64"
include Victor

module Gpx2Obj
  module UvMapping
    class SvgWriter
      WIREFRAME_WIDTH=256
      WIREFRAME_HEIGHT=256

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

      def build_svg(data, background: true, exclusions: [])
        cell_size = 1

        svg = SVG.new :viewBox => "0 0 #{WIREFRAME_WIDTH} #{WIREFRAME_HEIGHT}", "xmlns:xlink" => "http://www.w3.org/1999/xlink"
        svg.rect x: 0, y: 0, width: WIREFRAME_WIDTH, height: WIREFRAME_HEIGHT, fill: "#84A584"
        png_data = png_to_base64("00-Williams.png")
        svg.image :x => 0, :y => 0, width: WIREFRAME_WIDTH, :height => WIREFRAME_HEIGHT, "xlink:href" => "data:image/png;base64,#{png_data}"

        svg.css[".face"] = {opacity: 0.4}
        svg.css[".cell"] = {stroke: :white, rx: (cell_size * 0.1).round}

        # svg.g do
        #   WIREFRAME_WIDTH.times do |col|
        #     WIREFRAME_HEIGHT.times do |row|
        #       x = col * cell_size
        #       y = row * cell_size
        #       svg.rect class: "cell", x: x, y: y,
        #         width: cell_size, height: cell_size,
        #         fill: random_color_name
        #     end
        #   end
        # end

        svg.g do
          data.each do |id, surface|
            next if exclusions.include?(id)


            #draw_polygon(svg, id, surface)
            draw_path(svg, id, surface)
          end
        end

        svg
      end

      def draw_polygon(svg, id, surface)
        points = surface.map { |coordinate| coordinate.join(",") }.join(" ")
        svg.polygon points: points, fill: random_color_name, id: id, class: "face"
      end

      def draw_path(svg, id, surface)

        d = [].tap do |d|
          d = surface.each_with_index { |coordinate, i| d << "#{i == 0 ? 'M' ? 'L'} #{coordinate[0]} #{coordinate[1]} " }
        end
        svg.path d:, fill: random_color_name, id:, class: "face"
      end
    end
  end
end

svg = build_svg(data, background: true, exclusions: [186])
svg.save "wireframe"
