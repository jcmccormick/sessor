class CreateValues < ActiveRecord::Migration
  def change
  	remove_column :fields, :report_id
  	remove_column :fields, :value
    create_table :values do |t|
      t.text :key
      t.integer :field_id

      t.timestamps null: false
    end

    add_index :values, :field_id
  end
end
