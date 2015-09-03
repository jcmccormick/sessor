class RemoveCreatorIdFromTemplates < ActiveRecord::Migration
  def change
  	remove_column :templates, :creator_uid
  end
end
