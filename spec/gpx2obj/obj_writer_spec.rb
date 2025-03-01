require_relative "../spec_helper"

RSpec.describe Gpx2Obj::ObjWriter do
  let(:uv_mapping) { double(Gpx2Obj::UvMapping, uv_coordinates: [], uv_index: [], uv_offset: 0.0) }
  let(:model) { double("Model", faces:, vertices:, uv_mapping:) }
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

  subject { described_class.new(model) }

  describe "#content" do
    it "generates correct content format" do
      expected_content = <<~CONTENT
        mtllib model.mtl
        # id 0
        v 1.0 3.0 2.0
        # id 1
        v 4.0 6.0 5.0
        # 2 vertices

        usemtl white
        # id 1
        f 1 2
        # id 2
        f 2 3 4
        # 2 elements
      CONTENT

      expect(subject.content.strip).to eq(expected_content.strip)
    end
  end
end
