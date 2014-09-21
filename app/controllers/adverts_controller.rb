class AdvertsController < ApplicationController
  load_and_authorize_resource

  before_action :set_advert, only: [:show, :edit, :update, :destroy]
  before_action :set_typenames, only: [:new, :edit]
  before_action :set_categories, only: [:new, :edit]
  before_filter :authenticate_user!, except: [:index]

  # GET /adverts
  # GET /adverts.json
  def index
    @adverts = Advert.all.paginate(:page => params[:page], :per_page => 4)
  end

  # GET /adverts/1
  # GET /adverts/1.json
  def show
  end

  # GET /adverts/new
  def new
    @advert = Advert.new
    @current_category_name = set_categories[0]
  end

  # GET /adverts/1/edit
  def edit
    @current_category_name = @advert.category.name
  end

  # POST /adverts
  # POST /adverts.json
  def create
    @advert = Advert.new(advert_params)
    @advert.category_id = Category.find_by_name(advert_params[:category_id]).id

    current_user.adverts << @advert
    current_user.save
    respond_to do |format|
      if @advert.save
        format.html { redirect_to personal_cabinets_index_path, notice: 'Advert was successfully created.' }
        format.json { render :show, status: :created, location: @advert }
      else
        format.html { render :new }
        format.json { render json: @advert.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /adverts/1
  # PATCH/PUT /adverts/1.json
  def update
    successfully = @advert.update(advert_params)
    @advert.category_id = Category.find_by_name(advert_params[:category_id]).id
    @advert.save
    respond_to do |format|
      if successfully
        format.html { redirect_to @advert, notice: 'Advert was successfully updated.' }
        format.json { render :show, status: :ok, location: @advert }
      else
        format.html { render :edit }
        format.json { render json: @advert.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /adverts/1
  # DELETE /adverts/1.json
  def destroy
    @advert.destroy
    respond_to do |format|
      format.html { redirect_to adverts_url, notice: 'Advert was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_advert
      @advert = Advert.find(params[:id])
    end

    def set_typenames
      @type_names = ['sell', 'buy', 'exchange', 'service', 'loan']
    end

    def set_categories
      @categories_names = []
      Category.all.each do |category|
        @categories_names << category.name
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def advert_params
      params.require(:advert).permit(:title, :advert_type, :category_id, :body, :price, images_attributes: [:asset])
    end
end
