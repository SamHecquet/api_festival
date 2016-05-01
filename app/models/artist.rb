class Artist < ApplicationRecord
  has_many :festivals, through: :festival_artists
  has_many :festival_artists
  
  default_scope -> { order(headliner: :desc, name: :asc) }
  
  validates :name, presence: true
end
