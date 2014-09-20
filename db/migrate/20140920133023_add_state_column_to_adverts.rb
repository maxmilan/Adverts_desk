class AddStateColumnToAdverts < ActiveRecord::Migration
  def change
    add_column :adverts, :state, :string
    add_column :adverts, :type, :string
  end
end
