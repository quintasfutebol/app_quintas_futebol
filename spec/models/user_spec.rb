require 'rails_helper'

RSpec.describe User, type: :model do
  describe "associations" do
    it "has multiple accounts" do
      user = create(:user, :with_accounts, accounts_count: 3)
      expect(user.accounts.count).to eq(3)
    end
  end
end
