class PersonsController < ApplicationController
  def profile
    @adverts = current_user.adverts.paginate(:page => params[:page], :per_page => 4)
  end
end
