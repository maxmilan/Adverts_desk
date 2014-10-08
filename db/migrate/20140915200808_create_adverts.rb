class CreateAdverts < ActiveRecord::Migration
  def change
    create_table :adverts do |t|
      t.string :title
      t.text :body
      t.decimal :price

      t.timestamps
    end
  end
end
