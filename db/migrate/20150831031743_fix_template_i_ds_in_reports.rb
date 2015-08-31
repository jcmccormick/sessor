require_relative '20150830005228_add_template_i_ds_to_reports'

class FixTemplateIDsInReports < ActiveRecord::Migration
  def change
  	revert AddTemplateIDsToReports
  end
end