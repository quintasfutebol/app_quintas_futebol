require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  let(:password) { "securePassword123" }

  context "when user has only one account" do
    let(:user) { create(:user, :with_accounts, password: password, accounts_count: 1) }
    let(:account) { user.accounts.first }

    it "logs in and redirects to home path" do
      post session_path, params: { email_address: user.email_address, password: password }

      expect(response).to redirect_to(root_path)
      expect(session[:account_id]).to eq(account.id)
      expect(cookies[:session_id]).to be_present
    end
  end

  context "when user has multiple accounts" do
    let(:user) { create(:user, :with_accounts, password: password, accounts_count: 2) }

    it "logs in and redirects to account selection page" do
      post session_path, params: { email_address: user.email_address, password: password }

      expect(response).to redirect_to(accounts_selection_path)
      expect(session[:account_id]).to be_nil
    end
  end

  context "when user has one account and return path in session" do
    let(:user) { create(:user, :with_accounts, password: password, accounts_count: 1) }

    it "redirects to return_to_after_authenticating path after login" do
      allow_any_instance_of(SessionsController).to receive(:session)
        .and_return({ return_to_after_authenticating: "/protected/path" })

      post session_path, params: { email_address: user.email_address, password: password }

      expect(response).to redirect_to("/protected/path")
      expect(session[:return_to_after_authenticating]).to be_nil
    end
  end
end
