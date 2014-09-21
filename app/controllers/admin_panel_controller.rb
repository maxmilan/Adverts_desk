class AdminPanelController < ApplicationController
  def index
    @categories = Category.all.paginate(:page => params[:page], :per_page => 10)
  end

  def new_category
    @category = Category.new
  end
end
