class AddsGsKeyToTemplates < ActiveRecord::Migration
  def change
  	add_column :templates, :gs_key, :string
  end
end
