class RemoveCompatibleFromApplications < ActiveRecord::Migration[5.0]
  def change
    remove_column :applications, :compatible, :boolean
  end
end
