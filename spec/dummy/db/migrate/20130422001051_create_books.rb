class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :title
      t.float :price
      t.date :on_sell
      t.boolean :presence

      t.timestamps
    end
  end
end
