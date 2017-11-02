class AddCompatibleAndMerchantUsingToApplications < ActiveRecord::Migration[5.0]
  def change
    add_column :applications, :compatible, :boolean, default: true
    add_column :applications, :merchants_using, :string
  end
end
