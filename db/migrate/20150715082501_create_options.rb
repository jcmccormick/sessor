class CreateOptions < ActiveRecord::Migration
  def change
    create_table :options do |t|
      t.string :name
      t.integer :field_id
      t.timestamps null: false
    end

    add_index :options, :field_id
  end
end
