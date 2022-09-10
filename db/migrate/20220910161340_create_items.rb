class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.string :text
      t.references :number, null: false, foreign_key: true

      t.timestamps
    end
  end
end
