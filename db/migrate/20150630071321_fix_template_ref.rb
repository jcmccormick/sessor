class FixTemplateRef < ActiveRecord::Migration
  def change
  	remove_column :reports, :template_id, :integer
    add_reference :reports, :template, index: true, foreign_key: true
  end
end
