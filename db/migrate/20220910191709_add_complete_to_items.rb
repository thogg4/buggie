class AddCompleteToItems < ActiveRecord::Migration[7.0]
  def change
    add_column :items, :complete, :boolean, default: false
  end
end
