class AddAllowTitleToTemplates < ActiveRecord::Migration
  def change
    add_column :templates, :allow_title, :boolean
  end
end
