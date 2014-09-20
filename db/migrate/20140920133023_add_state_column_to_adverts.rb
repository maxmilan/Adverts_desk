class AddStateColumnToAdverts < ActiveRecord::Migration
  def change
    add_column :adverts, :state, :string
    add_column :adverts, :advert_type, :string
  end
end
