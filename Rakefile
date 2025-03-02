require_relative "lib/gpx2obj"

namespace :kaitai do
  desc "recompile Kaitai-Struct classes"
  task :recompile do
    system "kaitai-struct-compiler lib/gpx2obj/gp2shp.ksy --target ruby && mv gp2carshape.rb lib/gpx2obj/"
  end
end

namespace :gpx2obj do
  desc "convert model to obj"
  task :convert do
    uv_path = ENV.fetch("uv", "assets/texture.svg")
    input = ENV.fetch("input", "assets/carshape.shp")
    output = ENV.fetch("output", "out/")

    uv_mapping = if ['.yaml', '.yml'].include?(File.extname(uv_path))
      Gpx2Obj::UvMapping::YamlReader.new(uv_path)
    elsif File.extname(uv_path) == '.cfg'
      Gpx2Obj::UvMapping::CfgReader.new(uv_path)
    elsif File.extname(uv_path) == '.svg'
      Gpx2Obj::UvMapping::SvgReader.new(uv_path)
    else
      raise("Unsupported UV mapping: " + uv_path)
    end

    reader = Gpx2Obj::ShpReader.new(input, uv_mapping)

    FileUtils.mkdir_p(output) unless File.exist?(output)

    FileUtils.cp("assets/model.mtl", "#{output}/")
    FileUtils.cp("assets/00-RC-44.png", "#{output}/")
    reader.model1.write("#{output}/model1.obj", Gpx2Obj::ObjWriter)
    reader.model2.write("#{output}/model2.obj", Gpx2Obj::ObjWriter)
  end

  desc "Export texture.yaml to svg"
  task :texture_yaml_to_svg do
    uv_mapping = Gpx2Obj::UvMapping::YamlReader.new("assets/texture.cfg.yml")
    svg = Gpx2Obj::UvMapping::SvgWriter.new(uv_mapping).build_svg(background: true, exclusions: [186])
    svg.save "wireframe-offset2"
  end

  desc "Generate texture.cfg from SVG"
  task :svg_to_texture_cfg do

  end
end
