class AdminPanelController < ApplicationController
  authorize_resource :class => false

  def index
    @categories = Category.all.paginate(:page => params[:page], :per_page => 10)
    @users = User.all.paginate(:page => params[:page], :per_page => 10)
    @unpublished_adverts = Advert.unpublished
    @category = Category.new
  end
end