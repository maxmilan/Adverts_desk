# == Schema Information
#
# Table name: images
#
#  id                 :integer          not null, primary key
#  advert_id          :integer
#  created_at         :datetime
#  updated_at         :datetime
#  asset_file_name    :string(255)
#  asset_content_type :string(255)
#  asset_file_size    :integer
#  asset_updated_at   :datetime
#

class Image < ActiveRecord::Base
  belongs_to :advert

  has_attached_file :asset,
                    storage: :dropbox,
                    dropbox_credentials: "#{Rails.root}/config/dropbox_config.yml",
                    styles: { large: '800x800', medium: '400x400', small: '200x200', thumb: '100x100'},
                    dropbox_options:
			                {
	                      path: proc { |style| "#{style}/#{id}_#{asset.original_filename}" },
	                      unique_filename: true
	                    }
  validates_attachment_content_type :asset,
                                    content_type: ['image/jpg', 'image/jpeg', 'image/png', 'image/gif']
end
