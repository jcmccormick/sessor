class AddColumnOrderToFields < ActiveRecord::Migration
  def change
  	add_column :fields, :column_order, :integer
  end
end
