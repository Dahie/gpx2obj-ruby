module Gpx2Obj
  # Reader reads everything from the model file.
  # The terminology in GP2CarEditor of 1995 is a bit
  # messed up by modern sensibilities.
  #
  # GP2Careditor  => Today
  # Point         => Vertex
  # Vertex        => Edge
  # Texture       => Face
  # Within this file I will use the GP2Careditor terminology.
  # This reader serves as an interface to "modern" terminology
  # used in the rest of the project.
  class ShpReader
    attr_accessor :file_path, :uv_mapping

    DEF_CAR_START = 0x14C4A8
    HEADER_LENGTH = 106
    OFFSET_NOSE = 31
    OFFSET_PTS = 194
    TEXTURE_CFG_PATH = "assets/texture.cfg"

    def initialize(file_path, uv_mapping)
      @file_path = file_path
      @uv_mapping = uv_mapping
    end

    def car
      @car ||= Gp2carshape.from_file(file_path)
    end

    def model1
      @model1 ||= Model.new(car: car,
        vertices: translate_points(:model1),
        faces: read_textures(car.textures),
        uv_mapping: uv_mapping)
    end

    def model2
      @model2 ||= Model.new(car: car,
        vertices: translate_points(:model2),
        faces: read_textures(car.textures),
        uv_mapping: uv_mapping)
    end

    def points_count
      (car.header.vertex_begin - car.header.points_begin) / 8
    end

    def points_per_car_count
      points_count / 2
    end

    def points_per_car(model = :model1)
      return car.points[points_per_car_count..] if model == :model2

      car.points[0..points_per_car_count - 1]
    end

    private

    def translate_points(model = :model1)
      vertex_list = []
      points_per_car(model).each_with_index do |point, i|
        # puts "point #{i} - #{point.x}, #{point.y}, #{point.z}, #{point.u}"

        x = point.x
        y = point.y
        z = point.z
        pointxyz = Vertex.new(i, x, y, z)

        if pointxyz.z > 0x8000
          pointxyz.z = -(0x10000 - z)
        end

        if x < 0x8000
          if x > 0x80 && x < 0xFF
            idx = (x - 0x84) / 4
            idx += OFFSET_NOSE if model == :model2
            x = car.scales[idx]
            pointxyz.x = -x
          elsif x > 0
            idx = (x - 0x4) / 4
            idx += OFFSET_NOSE if model == :model2
            pointxyz.x = car.scales[idx]
          end

          if y > 0x80 && y < 0xFF
            idx = (y - 0x84) / 4
            idx += OFFSET_NOSE if model == :model2
            pointxyz.y = -car.scales[idx]

          elsif y > 0
            idx = (y - 0x04) / 4
            idx += OFFSET_NOSE if model == :model2
            pointxyz.y = car.scales[idx]
          end

        else
          pidx = x - 0x8000
          pointxyz.x = vertex_list[pidx].x
          pointxyz.y = vertex_list[pidx].y
        end

        vertex_list << pointxyz

        # puts "point final #{i} #{pointxyz.id} - #{pointxyz.x.to_f} #{pointxyz.y.to_f} #{pointxyz.z.to_f}"
      end

      vertex_list
    end

    def read_textures(buffer)
      idx = 0
      count = 0
      buffer.length

      textureData = {}

      187.times do
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
          until textureData[idx][:Args][-2] == 0 && textureData[idx][:Args][-1] == 0
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
          until textureData[idx][:Args][-2] == 0 && textureData[idx][:Args][-1] == 0
            2.times do
              textureData[idx][:Args] << buffer.getbyte(count)
              count += 1
            end
          end
        end

        textureData[idx][:numArgs] = textureData[idx][:Args].size
        parse_texture(textureData[idx])
        idx += 1
      end
      textureData
    end

    def parse_texture(texture_cmd)
      if texture_cmd[:cmd] >= 0x0 && texture_cmd[:cmd] < 0x7F
        start_arg = 5
        start_arg += 4 if texture_cmd[:Args][3] == 0x80
        start_arg = 1 if [0xa, 0x0].include?(texture_cmd[:cmd])

        texture_cmd[:edgeList] = []
        (start_arg...texture_cmd[:numArgs]).step(2) do |i|
          val = texture_cmd[:Args][i] + 256 * texture_cmd[:Args][i + 1]
          val = -0xffff + val - 1 if val > 65_000
          val -= 1 if val > 65_000
          texture_cmd[:edgeList] << val if val != 0
        end
      end
    end
  end
end
