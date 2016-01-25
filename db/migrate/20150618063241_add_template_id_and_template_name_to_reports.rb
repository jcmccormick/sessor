class AddTemplateIdAndTemplateNameToReports < ActiveRecord::Migration
  def change
    add_column :reports, :template_id, :integer
    add_column :reports, :template_name, :string
  end
end
