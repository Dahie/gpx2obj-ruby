require_relative "../spec_helper"
require "yaml"

RSpec.describe Gpx2Obj::ShpReader do
  let(:input_shp) { "spec/fixtures/carshape.shp" }
  let(:expected_values) { YAML.load_file("spec/fixtures/carshape.yaml") }
  subject { described_class.new(input_shp) }

  describe "#points_count" do
    it do
      expect(subject.points_count).to eq 388
    end
  end

  describe "#model1" do
    let(:expected_points) { expected_values.dig("model1", "points_translated").map { |p| p.split(", ").map(&:to_i).slice(1..) } }
    let(:points) { subject.model1.vertices.map { |v| [v.x, v.y, v.z] } }
    let(:textures) { subject.model1.faces }

    it "has expected points values" do
      # "".tap do |content|
      #   points.each_with_index do |p, i|
      #     next if p == expected_points[i]
      #     content << "#{i} " + p.inspect + " - " + expected_points[i].inspect + "\n"
      #   end
      # end

      # puts points.inspect
      # puts "--"
      # puts expected_points.inspect

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

    it "model one does not match model 2" do
      expect(subject.model1).to_not eq(subject.model2)
    end
  end

  describe "#model2" do
    let(:expected_vertices) { expected_values.dig("model2", "points_translated").map { |p| p.split(", ").map(&:to_i).slice(2..) } }
    let(:vertices) { subject.model2.vertices.map { |v| [v.x, v.y, v.z] } }
    let(:textures) { subject.model2.faces }

    it "has expected vertices values" do
      "".tap do |content|
        vertices.each_with_index do |p, i|
          next if p == expected_vertices[i]
          content << "#{i} " + p.inspect + " - " + expected_vertices[i].inspect + "\n"
        end
        puts content
      end


      # puts points.inspect
      # puts "--"
      # puts expected_points.inspect

      expect(vertices).to match_array(expected_vertices)
      expect(vertices).to eq(expected_vertices)
    end

    it "has expected vertices count" do
      expect(vertices.count).to eq 194
      expect(vertices.count).to eq vertices.count
    end

    it "has expected textures count" do
      expect(textures.count).to eq 187
    end

    it "returned vertices do not match model1" do
      expect(subject.model1).to_not eq(subject.model2)
    end
  end

  describe '#points_per_car' do
    it 'returns 194 vertices with model1' do
      expect(subject.points_per_car(:model1).count).to eq(194)
    end

    it 'returns 194 points with model2' do
      expect(subject.points_per_car(:model1).count).to eq(194)
    end

    it 'does not return same points for model1 and model2' do
      expect(subject.points_per_car(:model1)).to_not match_array(subject.points_per_car(:model2))
    end
  end
end
