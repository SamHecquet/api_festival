class CreateFestivals < ActiveRecord::Migration[5.0]
  def change
    create_table :festivals do |t|
      t.string :name
      t.string :url
      t.integer :year
      t.string :location
      t.string :date
      t.string :ticket
      t.boolean :camping
      t.string :website

      t.timestamps
    end
  end
end
