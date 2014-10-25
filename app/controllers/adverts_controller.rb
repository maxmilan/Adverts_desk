class AdvertsController < ApplicationController
  load_and_authorize_resource

  before_action :set_advert, only: [:show, :edit, :update, :destroy, :publicate, :accept, :reject, :reject_reason, :archivate]
  before_action :set_typenames, only: [:new, :edit, :index, :update, :create]
  before_action :initialize_logger
  before_filter :authenticate_user!, except: [:index]

  def index
    @search = Advert.published.ransack(params[:q])
    @adverts = @search.result.paginate(page: params[:page], per_page: 7)
    @categories_names = Category.pluck(:name)
  end

  def show
  end

  def new
    @advert = Advert.new
    @advert.images.build
  end

  def edit
	  @advert.images.build
  end

  def create
    @advert = Advert.new(advert_params)
    @advert.state = 'new'
    @advert.user = current_user
    @advert.save
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
	  @advert_logger.info("#{current_user.email} destroyed #{@advert.title}")
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

  def remove_image
		@image = Image.find(params[:image_id])
		@image.destroy
		respond_to do |format|
			format.js
		end
  end

  def reject_reason
    @advert.update_attributes(reject_reason: params[:advert][:reject_reason])
    @advert.reject
    @advert.save
    @advert_logger.info("Admin rejected #{@advert.title} because '#{@advert.reject_reason}'")
    redirect_to admin_panel_index_path
  end

  def reject
  end

  def search
		@adverts =
      if params[:query].empty?
        []
      else
        Advert.full_search(params)
      end
  end

  private

    def set_advert
      @advert = Advert.find(params[:id])
    end

    def set_typenames
      @type_names = %w{sell buy exchange service loan}
    end

    def destroy_empty_images(advert_params)
	      advert_params[:images_attributes] =
			      advert_params[:images_attributes].delete_if{|key,value|value.empty?} if advert_params[:images_attributes]
	      advert_params
		end

    def initialize_logger
	    @advert_logger ||= Logger.new("#{Rails.root}/log/notifications.log")
    end

    def advert_params
      destroy_empty_images params.require(:advert).permit(:title, :advert_type, :category_id, :body, :price, images_attributes: [:asset])
    end
end
