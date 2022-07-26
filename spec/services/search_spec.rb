# frozen_string_literal: true

RSpec.describe Services::Search do
  describe "#search" do
    context "it call ThinkingSphinx.search" do
      it "when type not select" do
        expect(ThinkingSphinx).to receive(:search).with('admin\\@example.com').and_call_original
        Services::Search.search_by("admin@example.com")
      end

      it "when type not exist" do
        expect(ThinkingSphinx).to receive(:search).with("Query").and_call_original
        Services::Search.search_by("Query", "Car")
      end
    end

    %w[Question Answer User Comment].each do |attr|
      it "call search with #{attr} type" do
        expect(attr.constantize).to receive(:search).with('admin\\@example.com').and_call_original
        Services::Search.search_by("admin@example.com", attr.to_s)
      end
    end

    it "return empty array" do
      expect(Services::Search.search_by("", "Answer")).to eq []
    end
  end
end
