class AddPlaceholderAndTooltipToFields < ActiveRecord::Migration
  def change
  	add_column :fields, :placeholder, :string
  	add_column :fields, :tooltip, :string
  end
end
