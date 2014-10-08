class AddAttachmentToImage < ActiveRecord::Migration
  def self.up
    add_attachment :images, :asset
  end
end