class CreateApplications < ActiveRecord::Migration[5.0]
  def change
    create_table :applications do |t|
      t.string :software
      t.string :gateway
      t.boolean :omaha
      t.boolean :nashville
      t.boolean :north
      t.boolean :buypass
      t.boolean :elavon
      t.boolean :tsys
      t.text :notes
      t.string :source
      t.string :agent
      t.string :ticket

      t.timestamps
    end
  end
end
