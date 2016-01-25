class AddDraftToTemplates < ActiveRecord::Migration
  def change
    add_column :templates, :draft, :boolean
  end
end
