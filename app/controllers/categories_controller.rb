class CategoriesController < ApplicationController
  before_action :set_category, only: [:destroy]

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    respond_to do |format|
      if @category.save
        format.html { redirect_to admin_panel_index_path, notice: 'Advert was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def destroy
    @category.destroy
    respond_to do |format|
      format.html { redirect_to admin_panel_index_path, notice: 'Advert was successfully destroyed.' }
    end
  end

private
  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name)
  end
end
