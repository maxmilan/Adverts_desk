class AdvertsController < ApplicationController
  load_and_authorize_resource

  before_action :set_advert, only: [:show, :edit, :update, :destroy, :publicate, :accept, :reject, :reject_reason, :archivate]
  before_action :set_typenames, only: [:new, :edit, :index, :update, :create]
  before_action :initialize_logger
  before_filter :authenticate_user!, except: [:index]

  def index
    @search = Advert.published.ransack(params[:q])
    @adverts = @search.result.paginate(:page => params[:page], :per_page => 7)
    @categories_names = []
    Category.find_each { |category| @categories_names << category.name }
  end

  def show
  end

  def new
    @advert = Advert.new
  end

  def edit
  end

  def create
    @advert = Advert.new(advert_params)
    @advert.state = "new"
    current_user.adverts << @advert
    current_user.save
    respond_to do |format|
      if @advert.save
        format.html { redirect_to persons_profile_url, notice: 'Advert was successfully created' }
        format.json { render :show, status: :created, location: @advert }
      else
        format.html { render action: 'new' }
        format.json { render json: @advert.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @advert.update_attributes(advert_params)
    @advert.refresh
    respond_to do |format|
      if @advert.save
        @advert_logger.info("#{current_user.email} updated #{@advert.title}")
        format.html { redirect_to persons_profile_url, notice: 'Advert was successfully updated' }
        format.json { render :show, status: :ok, location: @advert }
      else
        format.html { render action: 'edit' }
        format.json { render json: @advert.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
	  @advert_loger.info("#{current_user.email} destroyed #{@advert.title}")
    @advert.destroy
    respond_to do |format|
      format.html { redirect_to persons_profile_url, notice: 'Advert was successfully destroyed' }
      format.json { head :no_content }
    end
  end

  def publicate
    @advert.wait
    @advert.save
    @advert_logger.info("#{current_user.email} published #{@advert.title}")
    respond_to do |format|
      format.js
    end
  end

  def archivate
    @advert.send_to_archive
    @advert.save
    @advert_logger.info("#{current_user.email} archivated #{@advert.title}")
    respond_to do |format|
      format.js
    end
  end

  def accept
    @advert.accept
    @advert.save
    @advert_logger.info("Admin accepted #{@advert.title}")
    respond_to do |format|
      format.js
    end
  end

  def reject_reason
    @advert.update_attributes(:reject_reason => params[:advert][:reject_reason])
    @advert.reject
    @advert.save
    @advert_logger.info("Admin rejected #{@advert.title} because '#{@advert.reject_reason}'")
    redirect_to admin_panel_index_path
  end

  def reject

  end

  def search
		@adverts =
    unless params[:query].empty?
      Advert.full_search(params)
    else
      []
    end
  end

  private
    def set_advert
      @advert = Advert.find(params[:id])
    end

    def set_typenames
      @type_names = ['sell', 'buy', 'exchange', 'service', 'loan']
    end

    def initialize_logger
	    @advert_logger ||= Logger.new("#{Rails.root}/log/notifications.log")
    end

    def advert_params
      params.require(:advert).permit(:title, :advert_type, :category_id, :body, :price, images_attributes: [:asset])
    end
end
