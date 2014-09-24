class PersonsController < ApplicationController
  def profile
    @adverts = current_user.adverts.order(created_at: :desc).paginate(:page => params[:page], :per_page => 4)
  end
end
