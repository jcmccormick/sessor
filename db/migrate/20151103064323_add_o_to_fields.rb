class AddOToFields < ActiveRecord::Migration
  def change
    add_column :fields, :o, :text
  end
end
