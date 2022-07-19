# frozen_string_literal: true

RSpec.describe Services::DailyDigest do
  let(:users) { create_list(:user, 3) }

  it "send daily digest to all users" do
    users.each { |user| expect(DailyDigestMailer).to receive(:digest).with(user).and_call_original }
    subject.send_digest
  end
end
