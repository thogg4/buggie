class AddRemindAtToItems < ActiveRecord::Migration[7.0]
  def change
    add_column :items, :remind_at, :datetime
  end
end
