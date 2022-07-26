# frozen_string_literal: true

RSpec.describe ReputationJob, type: :job do
  describe "reputation" do
    let(:question) { create(:question) }

    it "call Services::Reputation#calculate" do
      expect(Services::Reputation).to receive(:calculate).with(question)
      ReputationJob.perform_now(question)
    end
  end
end
