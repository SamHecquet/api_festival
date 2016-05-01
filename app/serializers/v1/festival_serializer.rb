class V1::FestivalSerializer < ActiveModel::Serializer
  attributes :id, :name, :full_name, :url, :year, :location, :date, :ticket, :camping, :website
  
  has_many :artists
  
  def full_name
    "#{object.name} #{object.year}" 
  end
end
