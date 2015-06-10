class AddParticipantsToReports < ActiveRecord::Migration
  def change
    add_column :reports, :participants, :string
  end
end
