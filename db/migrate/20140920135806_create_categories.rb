class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name

      t.timestamps
    end

    change_table :adverts do |t|
      t.belongs_to :category
    end
  end
end
