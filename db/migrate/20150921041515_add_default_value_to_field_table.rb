class AddDefaultValueToFieldTable < ActiveRecord::Migration
  def change
  	add_column :fields, :default_value, :text
  end
end
