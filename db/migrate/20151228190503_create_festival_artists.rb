class CreateFestivalArtists < ActiveRecord::Migration[5.0]
  def change
    create_table :festival_artists do |t|
      t.integer :festival_id, :artist_id
    end
  end
end
