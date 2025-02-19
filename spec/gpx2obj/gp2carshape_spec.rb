require_relative "../spec_helper"
require "yaml"

RSpec.describe Gp2carshape do
  subject(:car) { Gp2carshape.from_file("spec/fixtures/carshape.shp") }
  let(:expected_values) { YAML.load_file("spec/fixtures/carshape.yaml") }

  describe "#scales" do
    let(:expected_scales) { expected_values.dig("generic", "scales").map(&:to_i) }

    it "has expected scales count" do
      expect(car.scales.count).to eq 62
      expect(car.scales.count).to eq expected_scales.count
    end

    it "has expected scale values" do
      scales = car.scales

      expect(scales).to match_array(expected_scales)
      expect(scales).to eq(expected_scales)
    end
  end

  describe "#points" do
    let(:expected_points) { expected_values.dig("generic", "points_raw").map { |p| p.split(" ").map(&:to_i).slice(1..-2) } }
    let(:points) { car.points.map { |p| [p.x, p.y, p.z] } }

    it "has expected points count" do
      expect(car.points.count).to eq 388
      expect(car.points.count).to eq expected_points.count
    end

    it "has expected points values" do
      expect(points).to match_array(expected_points)
      expect(points).to eq(expected_points)
    end
  end

  describe "#vertices" do
    let(:expected_vertices) { expected_values.dig("model1", "vertices").map { |p| p.split(" ").map(&:to_i) } }

    it "has expected vertices count" do
      expect(car.vertices.count).to eq 301
    end

    it "has expected vertex values" do
      vertices = car.vertices.map { |v| [v.from, v.to, v.a, v.b] }

      expect(vertices).to match_array(expected_vertices)
      expect(vertices).to eq(expected_vertices)
    end
  end
end
