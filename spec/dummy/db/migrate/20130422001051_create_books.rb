class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :title
      t.float :price
      t.date :on_sell
      t.boolean :presence
      t.references :category
      t.timestamps
    end
  end
end
