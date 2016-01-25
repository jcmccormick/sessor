class CreateTemplates < ActiveRecord::Migration
  def change
    create_table :templates do |t|
      t.string :name
      t.text :design
      t.string :creator_uid
      t.boolean :private_world
      t.boolean :private_group
      t.integer :group_id
      t.boolean :group_edit
      t.text :group_editors

      t.timestamps null: false
    end
  end
end
