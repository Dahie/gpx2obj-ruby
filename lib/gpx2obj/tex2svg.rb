require_relative "../gpx2obj"
require "victor"
require "base64"
include Victor

def parse_texture_file(file_path)
  file = File.open(file_path)
  data = {}
  file.readlines.map(&:chomp).each do |line|
    line.strip!
    next if line.empty?
    next if line.start_with?("//") # Skip comment lines

    parts = line.split(",").map(&:strip)
    first_part = parts[0]

    next if first_part == "0" || first_part == "1"

    index = first_part.to_i
    coordinates = []
    (2..parts.length - 2).step(2) do |i|
      x = parts[i].to_i
      y = parts[i + 1].to_i
      coordinates << [x, y]
    end

    data[index] = coordinates
  end

  file.close

  data
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

def draw_polygon(svg, id, surface)
  points = surface.map { |coordinate| coordinate.join(",") }.join(" ")
  svg.polygon points: points, fill: random_color_name, id: id, class: "face"
end

def draw_path(svg, id, surface)

  d = [].tap do |d|
    d = surface.each_with_index { |coordinate, i| d << "#{i == 0 ? 'M' : 'L'} #{coordinate[0]} #{coordinate[1]} " }
  end
  svg.path d:, fill: random_color_name, id:, class: "face"
end

def build_svg(uv_mapping, background: true, exclusions: [])
  total_width = 256
  total_height = 256
  cell_size = 1

  svg = SVG.new :viewBox => "0 0 #{total_width} #{total_height}", "xmlns:xlink" => "http://www.w3.org/1999/xlink"
  svg.rect x: 0, y: 0, width: total_width, height: total_height, fill: "#84A584"
  png_data = png_to_base64("assets/00-Williams.png")
  svg.image :x => 0, :y => 0, :width => total_width, :height => total_height, "xlink:href" => "data:image/png;base64,#{png_data}"

  svg.css[".face"] = {opacity: 0.6}
  svg.css[".hidden"] = {display: "none"}
  svg.css[".cell"] = {stroke: :white, rx: (cell_size * 0.1).round}

  # svg.g do
  #   total_width.times do |col|
  #     total_height.times do |row|
  #       x = col * cell_size
  #       y = row * cell_size
  #       svg.rect class: "cell", x: x, y: y,
  #         width: cell_size, height: cell_size,
  #         fill: random_color_name
  #     end
  #   end
  # end

  uv_mapping.groups.each do |group|
    svg.g(id: group["title"]) do
      group["faces"].each do |id, face|
        next if exclusions.include?(id)

        #draw_polygon(svg, id, face)
        draw_path(svg, id, face['uv'])
      end
    end
  end

  svg
end

# data = parse_texture_file("assets/texture.cfg")
uv_mapping = Gpx2Obj::UvMapping::YamlReader.new("assets/texture.cfg.yml")
svg = build_svg(uv_mapping, background: true, exclusions: [186])
svg.save "wireframe"
