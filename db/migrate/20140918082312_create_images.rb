class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.belongs_to :advert

      t.timestamps
    end
  end
end