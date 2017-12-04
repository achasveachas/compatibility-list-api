class RemoveNotesFromApplications < ActiveRecord::Migration[5.0]
  def change
    remove_column :applications, :notes, :string
  end
end
