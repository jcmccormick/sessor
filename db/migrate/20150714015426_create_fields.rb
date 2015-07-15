class CreateFields < ActiveRecord::Migration
  def change
    create_table :fields do |t|
      t.string :name
      t.string :type
      t.text :value
      t.boolean :required
      t.boolean :disabled
      t.timestamps null: false
    end
  end
end
