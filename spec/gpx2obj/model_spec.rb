require_relative "../spec_helper"

RSpec.describe Gpx2Obj::Model do
  let(:car) { double("Car", header: {}, scales: [], vertices: [], points: []) }
  let(:vertices) do
    [
      double("Point", x: 10, y: 20, z: 30),
      double("Point", x: 40, y: 50, z: 60)
    ]
  end
  let(:faces) do
    {
      1 => {PtsList: [1, 2]},
      2 => {PtsList: [2, 3, 4]}
    }
  end
  let(:edges) do
    [
      OpenStruct.new(from: 1, to: 2),
      OpenStruct.new(from: 2, to: 0),
      OpenStruct.new(from: 1, to: 2),
      OpenStruct.new(from: 1, to: 2)
    ]
  end

  subject { described_class.new(car:, vertices:, faces:) }

  describe "#initialize" do
    it "assigns car, vertices, and faces" do
      expect(subject.car).to eq(car)
      expect(subject.vertices).to eq(vertices)
      expect(subject.faces).to eq(faces)
    end
  end

  describe "#write" do
    let(:file_name) { "test.obj" }
    let(:expected_content) { "g\n# id 0\nv 1.0 3.0 2.0\n# id 1\nv 4.0 6.0 5.0\n# 2 vertices\n\ng car\nusemtl white\n# id 1\nf 1 2\n# id 2\nf 2 3 4\n# 2 elements\n" }

    it "writes content to a file" do
      expect(Gpx2Obj::ObjWriter).to receive(:new).with(subject).and_call_original
      expect(File).to receive(:write).with(file_name, expected_content)
      subject.write(file_name, Gpx2Obj::ObjWriter)
    end
  end
end
