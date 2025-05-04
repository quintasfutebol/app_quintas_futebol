require 'rails_helper'

RSpec.describe Account, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe "#generate_slug" do
    it "generates a slug from the name before validation" do
      account = Account.new(name: "Futebol Clube do Bairro")
      account.valid?
      expect(account.slug).to eq("futebol-clube-do-bairro")
    end

    it "does not overwrite an existing slug" do
      account = Account.new(name: "Meu Clube", slug: "custom-slug")
      account.valid?
      expect(account.slug).to eq("custom-slug")
    end
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
