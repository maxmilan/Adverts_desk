class AddAdvertUserRelationship < ActiveRecord::Migration
  def change
    change_table :adverts do |t|
      t.belongs_to :user
    end
  end
end
