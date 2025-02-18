# https://github.com/paulhoad/gp2careditor/blob/master/Car.h
meta:
  id: gp2carshape
  title: GrandPrix2 Car shape
  application: GP2 Careditor by Paul Hoad
  file-extension: shp
  endian: le
  xref:
    justsolve: Warcraft_II_PUD  # https://en.wikipedia.org/wiki/Grand_Prix_2
    wikidata: Q28009492
  license: CC0-1.0
  ks-version: 0.6
seq:
  - id: header
    type: header
    size: 106
instances:
  scales:
    pos: 106
    type: s2
    repeat: expr
    repeat-expr: (_root.header.scale_end - _root.header.scale_begin) / 2
  textures:
    pos: (_root.header.texture_begin - _root.header.scale_begin) + 106
    size: (_root.header.points_begin - _root.header.texture_begin) +106
  points:
    type: point
    pos: (_root.header.points_begin - _root.header.scale_begin) + 106
    repeat: expr
    repeat-expr: (_root.header.vertex_begin - _root.header.points_begin) / 8
  vertices:
    pos: (_root.header.vertex_begin - _root.header.scale_begin) + 106
    type: vertex
    repeat: expr
    repeat-expr: ((_root.header.vertex_end - _root.header.vertex_begin) / 4) -4
  unks:
    type: s2
    pos: (_root.header.vertex_end - _root.header.scale_begin) + 106
    repeat: expr
    repeat-expr: (_root.header.file_end - _root.header.vertex_end) / 2
types:
  header:
    seq:
      - id: magic
        contents: [0x02, 0x80]
      - id: id
        type: s2
      - id: scale_begin
        type: u4
      - id: scale_end
        type: u4
      - id: texture_begin
        type: u4
      - id: points_begin
        type: u4
      - id: vertex_begin
        type: u4
      - id: texture_end
        type: u4
      - id: vertex_end
        type: u4
      - id: file_end
        type: u4
      - id: file_end2
        type: u4
      - id: always0
        type: u4
      - id: always1
        type: u4
      - id: unk
        type: s2
      - id: size
        type: u2
      - id: size8
        type: u2

  vertex:
    seq:
      - id: from
        type: u1
      - id: to
        type: u1
      - id: a
        type: u1
      - id: b
        type: u1
  point:
    seq:
      - id: x
        type: u2
      - id: y
        type: u2
      - id: z
        type: u2
      - id: u
        type: u2
  texture_cmd:
    seq:
      - id: numl
        type: u1
      - id: numh
        type: u1
      - id: cmd
        type: u1
      - id: args_0x80
        size: 7
        if: cmd == 0x80
      - id: args_0x90
        size: 7
        if: cmd == 0x90
      - id: args_0x13
        size: 15
        if: cmd == 0x13

        
