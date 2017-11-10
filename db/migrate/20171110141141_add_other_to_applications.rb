class AddOtherToApplications < ActiveRecord::Migration[5.0]
  def change
    add_column :applications, :other, :boolean, default: false
  end
end
