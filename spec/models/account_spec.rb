require 'rails_helper'

RSpec.describe Account, type: :model do
  describe 'associations' do
    it { is_expected.to have_and_belong_to_many(:users) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end

  context 'when associating users' do
    let(:account) { create(:account) }
    let(:users) { create_list(:user, 2) }

    before { account.users << users }

    it 'has multiple users' do
      expect(account.users.count).to eq(2)
    end
  end
end
