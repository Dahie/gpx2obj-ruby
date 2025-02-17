# https://doc.kaitai.io/
require_relative 'gp2car'


DEF_CAR_START = 0x14C4A8
HEADER_LENGTH = 106

car = Gp2car.from_file('../high-nose.shp')

header = car.header


num_verticies = header.size8 / 8;
num_scale = (header.scale_end - header.scale_begin) / 2;
puts "Scales: #{num_scale}"
num_points = (header.vertex_begin - header.points_begin) / 8;
num_unks = (header.file_end - header.vertex_end) / 2;

puts "Points: #{num_points}"

num_verticies = (header.vertex_end - header.vertex_begin) / 4;

puts "Verticies: #{num_verticies}"
puts "Unks: #{num_unks}"

puts "---"

puts header.magic.inspect
puts header.id.inspect
puts header.scale_begin
puts header.scale_end
puts header.texture_begin
puts header.vertex_begin
puts header.vertex_end
puts header.points_begin
puts header.texture_end

puts "---"

puts HEADER_LENGTH + (header.scale_begin - header.scale_begin) # scale begin
puts HEADER_LENGTH + (header.scale_end - header.scale_begin) # scale end
puts HEADER_LENGTH + (header.texture_begin - header.scale_begin) # texture begin
puts HEADER_LENGTH + (header.texture_end - header.scale_begin) # texture end
puts HEADER_LENGTH + (header.points_begin - header.scale_begin) #points begin
puts HEADER_LENGTH + (header.vertex_begin - header.scale_begin) # vertex begin
puts HEADER_LENGTH + (header.vertex_end - header.scale_begin) # vertex end
# puts HEADER_LENGTH + (header.points_end - header.scale_begin) #points end

puts header.inspect

puts '-----'

puts car.scales.count
# puts car.scales.inspect

# File.write('out/scales.csv', car.scales.map{|s| s }.join("\n"))
# File.write('out/vertices.csv', car.verticies.join('\n'))
# File.write('out/points.csv', car.points.join('\n'))

class Vertex
  attr_reader :id, :connected, :id
  attr_accessor :y, :x, :z

  def initialize(id, x, y, z)
    @id = id
    @x = x
    @y = y
    @z = z
    @connected = Set.new
  end

  def connect(c_vertex)
    @connected.add(c_vertex.id)
  end
end


# puts car.points.count
vertex_list = []
car.points.each_with_index do |point, i|
  # puts "point #{i} - #{point.x}, #{point.y}, #{point.z}, #{point.u}"

  x = point.x
  y = point.y
  z = point.z
  pointxyz = Vertex.new(i, x, y, z)

  pointxyz.z = -(0x10000 - z) if pointxyz.z > 0x8000

  if x < 0x8000
    if x > 0x80 && x < 0xFF
      idx = (x - 0x84) / 4;
      # todo if (HiNose) idx += OFFSET_NOSE;
      x = car.scales[idx];
      pointxyz.x = -x;
    elsif x > 0
      idx = (x - 0x4) / 4;
      # todo if (HiNose) idx += OFFSET_NOSE;
      pointxyz.x = car.scales[idx];
    end

    if y > 0x80 && y < 0xFF
      idx = (y - 0x84) / 4
      #todo if (HiNose) idx += OFFSET_NOSE;
      y = car.scales[idx]
      pointxyz.y = -y

    elsif y > 0
      idx = (y - 0x04) / 4;
      #todo if (HiNose) idx += OFFSET_NOSE;
      pointxyz.y = car.scales[idx];
    end

  else
    pidx = x - 0x8000;
    pointxyz.x = car.points[pidx].x;
    pointxyz.y = car.points[pidx].y;
  end

  vertex_list << pointxyz

  # puts "point final #{i} #{pointxyz.id} - #{pointxyz.x.to_f} #{pointxyz.y.to_f} #{pointxyz.z.to_f}"
end

# puts car.verticies.count
# car.verticies.each_with_index do |vertex, i|
#   puts "vertex #{i} - #{vertex.from}, #{vertex.to}, #{vertex.a}, #{vertex.b}"
# end


def read_textures(buffer)
  puts buffer.inspect

  idx = 0
  count = 0
  total = buffer.length

  textureData = {}

  187.times do
    puts "#{count}/#{total}"
    numl = buffer.getbyte(count)
    count += 1
    numh = buffer.getbyte(count)
    count += 1
    cmd = buffer.getbyte(count)
    count += 1

    textureData[idx] = {
      numl: numl,
      numh: numh,
      cmd: cmd,
      Args: []
    }

    n_args = 0

    case cmd
    when 0x80, 0x90
      7.times do
        textureData[idx][:Args] << buffer.getbyte(count)
        count += 1
      end
    when 0x13
      15.times do
        textureData[idx][:Args] << buffer.getbyte(count)
        count += 1
      end
      if textureData[idx][:Args][3] == 0x80
        2.times do
          textureData[idx][:Args] << buffer.getbyte(count)
          count += 1
        end
      end
    when 0x18, 0x11, 0x1a, 0x16, 0x17, 0x12, 0x15, 0x10, 0x0
      11.times do
        textureData[idx][:Args] << buffer.getbyte(count)
        count += 1
      end
      while !(textureData[idx][:Args][-2] == 0 && textureData[idx][:Args][-1] == 0)
        2.times do
          textureData[idx][:Args] << buffer.getbyte(count)
          count += 1
        end
      end
    when 0xa
      5.times do
        textureData[idx][:Args] << buffer.getbyte(count)
        count += 1
      end
      while !(textureData[idx][:Args][-2] == 0 && textureData[idx][:Args][-1] == 0)
        2.times do
          textureData[idx][:Args] << buffer.getbyte(count)
          count += 1
        end
      end
    end

    textureData[idx][:numArgs] = textureData[idx][:Args].size
    parse_texture(textureData[idx])
    puts textureData[idx]
    idx += 1
  end
  textureData
end


def parse_texture(texture_cmd)
  if texture_cmd[:cmd] >= 0x0 && texture_cmd[:cmd] < 0x7F
    start_arg = 5
    start_arg += 4 if texture_cmd[:Args][3] == 0x80
    start_arg = 1 if [0xa, 0x0].include?(texture_cmd[:cmd])

    texture_cmd[:PtsList] = []
    (start_arg...texture_cmd[:numArgs]).step(2) do |i|
      val = texture_cmd[:Args][i] + 256 * texture_cmd[:Args][i + 1]
      val = -0xffff+val-1 if val > 65_000
      texture_cmd[:PtsList] << val if val != 0
    end
  end
end

faces = read_textures(car.textures)


#face_list.each { |face| puts face.inspect }
