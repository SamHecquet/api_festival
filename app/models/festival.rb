class Festival < ApplicationRecord
  has_many :festival_artists, dependent: :destroy
  has_many :artists, through: :festival_artists
  
  validates :name, presence: true
  validates :url, presence: true
end
