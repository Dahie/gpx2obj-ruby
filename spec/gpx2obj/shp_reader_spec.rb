require_relative "../spec_helper"
require "yaml"

RSpec.describe Gpx2Obj::ShpReader do
  let(:input_shp) { "spec/fixtures/carshape.shp" }
  let(:expected_values) { YAML.load_file("spec/fixtures/carshape.yaml") }
  subject { described_class.new(input_shp) }

  describe '#points_count' do
    it do
      expect(subject.points_count).to eq 388
    end
  end

  describe "#model1" do
    let(:expected_points) { expected_values.dig("model1", "points_translated").map { |p| p.split(" ").map(&:to_i).slice(2..-1) } }
    let(:points) { subject.model1.vertices.map { |v| [v.x, v.y, v.z] } }
    let(:textures) { subject.model1.faces }

    it "has expected points values" do

      "".tap do |content|
        points.each_with_index do |p, i|
          next if p == expected_points[i]
          content <<  "#{i} " +  p.inspect + " - "  + expected_points[i].inspect + "\n"
        end
        File.write('out/debug_raw_points.csv', content)
      end

      puts points.inspect
      puts "--"
      puts expected_points.inspect

      expect(points).to match_array(expected_points)
      expect(points).to eq(expected_points)
    end

    it "has expected points count" do
      expect(points.count).to eq 194
      expect(points.count).to eq expected_points.count
    end

    it "has expected textures count" do
      expect(textures.count).to eq 187
    end
  end
end
