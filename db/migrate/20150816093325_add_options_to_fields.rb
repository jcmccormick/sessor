class AddOptionsToFields < ActiveRecord::Migration
  def change
    add_column :fields, :options, :text
  end
end
