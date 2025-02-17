# This is a generated file! Please edit source .ksy file and use kaitai-struct-compiler to rebuild

require 'kaitai/struct/struct'

unless Gem::Version.new(Kaitai::Struct::VERSION) >= Gem::Version.new('0.9')
  raise "Incompatible Kaitai Struct Ruby API: 0.9 or later is required, but you have #{Kaitai::Struct::VERSION}"
end

class Gp2carshape < Kaitai::Struct::Struct
  def initialize(_io, _parent = nil, _root = self)
    super(_io, _parent, _root)
    _read
  end

  def _read
    @_raw_header = @_io.read_bytes(106)
    _io__raw_header = Kaitai::Struct::Stream.new(@_raw_header)
    @header = Header.new(_io__raw_header, self, @_root)
    self
  end
  class Header < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      _read
    end

    def _read
      @magic = @_io.read_bytes(2)
      raise Kaitai::Struct::ValidationNotEqualError.new([2, 128].pack('C*'), magic, _io, "/types/header/seq/0") if not magic == [2, 128].pack('C*')
      @id = @_io.read_s2le
      @scale_begin = @_io.read_u4le
      @scale_end = @_io.read_u4le
      @texture_begin = @_io.read_u4le
      @points_begin = @_io.read_u4le
      @vertex_begin = @_io.read_u4le
      @texture_end = @_io.read_u4le
      @vertex_end = @_io.read_u4le
      @file_end = @_io.read_u4le
      @file_end2 = @_io.read_u4le
      @always0 = @_io.read_u4le
      @always1 = @_io.read_u4le
      @unk = @_io.read_s2le
      @size = @_io.read_u2le
      @size8 = @_io.read_u2le
      self
    end
    attr_reader :magic
    attr_reader :id
    attr_reader :scale_begin
    attr_reader :scale_end
    attr_reader :texture_begin
    attr_reader :points_begin
    attr_reader :vertex_begin
    attr_reader :texture_end
    attr_reader :vertex_end
    attr_reader :file_end
    attr_reader :file_end2
    attr_reader :always0
    attr_reader :always1
    attr_reader :unk
    attr_reader :size
    attr_reader :size8
  end
  class Vertex < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      _read
    end

    def _read
      @from = @_io.read_u1
      @to = @_io.read_u1
      @a = @_io.read_u1
      @b = @_io.read_u1
      self
    end
    attr_reader :from
    attr_reader :to
    attr_reader :a
    attr_reader :b
  end
  class Point < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      _read
    end

    def _read
      @x = @_io.read_u2le
      @y = @_io.read_u2le
      @z = @_io.read_u2le
      @u = @_io.read_u2le
      self
    end
    attr_reader :x
    attr_reader :y
    attr_reader :z
    attr_reader :u
  end
  class TextureCmd < Kaitai::Struct::Struct
    def initialize(_io, _parent = nil, _root = self)
      super(_io, _parent, _root)
      _read
    end

    def _read
      @numl = @_io.read_u1
      @numh = @_io.read_u1
      @cmd = @_io.read_u1
      if cmd == 128
        @args_0x80 = @_io.read_bytes(7)
      end
      if cmd == 144
        @args_0x90 = @_io.read_bytes(7)
      end
      if cmd == 19
        @args_0x13 = @_io.read_bytes(15)
      end
      self
    end
    attr_reader :numl
    attr_reader :numh
    attr_reader :cmd
    attr_reader :args_0x80
    attr_reader :args_0x90
    attr_reader :args_0x13
  end
  def points
    return @points unless @points.nil?
    _pos = @_io.pos
    @_io.seek(((_root.header.points_begin - _root.header.scale_begin) + 106))
    @points = []
    (((_root.header.vertex_begin - _root.header.points_begin) / 8)).times { |i|
      @points << Point.new(@_io, self, @_root)
    }
    @_io.seek(_pos)
    @points
  end
  def scales
    return @scales unless @scales.nil?
    _pos = @_io.pos
    @_io.seek(106)
    @scales = []
    (((_root.header.scale_end - _root.header.scale_begin) / 2)).times { |i|
      @scales << @_io.read_s2le
    }
    @_io.seek(_pos)
    @scales
  end
  def vertices
    return @vertices unless @vertices.nil?
    _pos = @_io.pos
    @_io.seek(((_root.header.vertex_begin - _root.header.scale_begin) + 106))
    @vertices = []
    ((((_root.header.vertex_end - _root.header.vertex_begin) / 4) + 1)).times { |i|
      @vertices << Vertex.new(@_io, self, @_root)
    }
    @_io.seek(_pos)
    @vertices
  end
  def textures
    return @textures unless @textures.nil?
    _pos = @_io.pos
    @_io.seek(((_root.header.texture_begin - _root.header.scale_begin) + 106))
    @textures = @_io.read_bytes(((_root.header.points_begin - _root.header.texture_begin) + 106))
    @_io.seek(_pos)
    @textures
  end
  def unks
    return @unks unless @unks.nil?
    _pos = @_io.pos
    @_io.seek(((_root.header.vertex_end - _root.header.scale_begin) + 106))
    @unks = []
    (((_root.header.file_end - _root.header.vertex_end) / 2)).times { |i|
      @unks << @_io.read_s2le
    }
    @_io.seek(_pos)
    @unks
  end
  attr_reader :header
  attr_reader :_raw_header
end
