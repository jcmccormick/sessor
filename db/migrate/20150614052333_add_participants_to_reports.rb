class AddParticipantsToReports < ActiveRecord::Migration
  def change
    add_column :reports, :participants, :text
  end
end
