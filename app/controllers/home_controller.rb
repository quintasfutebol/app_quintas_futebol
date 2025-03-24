class HomeController < ApplicationController
  allow_unauthenticated_access only: [ :index ]
  before_action :resume_session, only: [ :index ]

  def index
    respond_to do |format|
      format.html
    end
  end
end
