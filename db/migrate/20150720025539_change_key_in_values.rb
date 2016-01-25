class ChangeKeyInValues < ActiveRecord::Migration
  def change
  	rename_column :values, :key, :input
  end
end
