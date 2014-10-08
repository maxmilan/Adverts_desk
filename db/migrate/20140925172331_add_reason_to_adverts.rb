class AddReasonToAdverts < ActiveRecord::Migration
  def change
    add_column :adverts, :reject_reason, :text
  end
end
