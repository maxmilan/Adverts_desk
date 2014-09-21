class AdminPanelController < ApplicationController
  def index
    @categories = Category.all.paginate(:page => params[:page], :per_page => 10)
    @users = User.all.paginate(:page => params[:page], :per_page => 10)
  end
end
