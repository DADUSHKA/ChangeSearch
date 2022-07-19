# frozen_string_literal: true

RSpec.describe LinksController, type: :controller do
  let(:user) { create(:user) }
  let(:user1) { create(:user) }
  let!(:question) { create(:question, author: user) }
  let!(:link) { create(:link, linkable: question) }
  let(:delete_action) { delete :destroy, params: { id: link.id }, format: :js }

  describe "DELETE #destroy" do
    it "author deletes link" do
      sign_in(user)

      expect { delete_action }.to change { Link.count }.by(-1)
      expect(response).to render_template :destroy
    end

    it "non-author user doesnt deletes link" do
      sign_in(user1)

      expect { delete_action }.not_to change { Link.count }
      expect(response).to render_template :destroy
    end
  end
end
