class AddGooglerToUsers < ActiveRecord::Migration
  def change
    add_column :users, :googler, :string
  end
end
