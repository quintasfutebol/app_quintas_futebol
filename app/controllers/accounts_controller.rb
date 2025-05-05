class AccountsController < ApplicationController
  def select
    @accounts = Current.user.accounts
  end

  def set
    account = Current.user.accounts.find_by!(slug: params[:slug])
    session[:account_id] = account.id

    redirect_to home_index_path
  end
end
