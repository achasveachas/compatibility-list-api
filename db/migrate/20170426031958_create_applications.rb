class CreateApplications < ActiveRecord::Migration[5.0]
  def change
    create_table :applications do |t|
      t.belongs_to :user, foreign_key: true
      t.string :software
      t.string :gateway
      t.boolean :omaha, default: false
      t.boolean :nashville, default: false
      t.boolean :north, default: false
      t.boolean :buypass, default: false
      t.boolean :elavon, default: false
      t.boolean :tsys, default: false
      t.text :notes
      t.string :source
      t.string :agent
      t.string :ticket

      t.timestamps
    end
  end
end
