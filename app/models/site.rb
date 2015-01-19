class Site
  include Mongoid::Document
  include SimpleEnum::Mongoid

  attr_accessor :distance
  
  field :name,         type: String
  field :street,       type: String
  belongs_to :city
  belongs_to :state
  belongs_to :zip
  
  field :geo_location,       type: Hash
  field :hours,              type: String
  
  field :distribution_method, type: String
  field :distribution_frequency, type: String
  
  has_and_belongs_to_many :populations
  belongs_to :agency

  before_save :set_geo_location

  index({ geo_location: "2dsphere" })

  def address_string
    "#{street}, #{city.try(:name)}, #{state.try(:name)}, #{zip.try(:code)}" 
  end

  def lat
    geo_location.try(:[], 'coordinates').try(:last)
  end

  def lng
    geo_location.try(:[], 'coordinates').try(:first)
  end
  
  def set_geo_location
    res = Geocoder.search(address_string).first
    res = res.try(:data)
    res = res.try(:[], 'geometry')
    res = res.try(:[], 'location')
    lat = res.try(:[], 'lat')
    lng = res.try(:[], 'lng')

    if lat && lng
      self.geo_location = { type: 'Point', coordinates: [lng, lat] }
    end
  end
  
  rails_admin do
    exclude_fields :_id, :geo_location

    field :name

    field :hours do
      group :details
    end

    field :distribution_method do
      group :details
    end
    
    field :populations do
      group :details
    end

    field :agency do
      group :details
    end

    field :distribution_frequency do
      group :details
    end
    
    group :details
    group :location
    
    field :street do
      group :location
    end
    
    field :city do
      group :location
    end
    
    field :state do
      group :location
    end
    
    field :zip do
      group :location
    end

    field :lng do
      label "Longitude"
      read_only true
      group :location
    end
    
    field :lat do
      label "Latitude"
      read_only true
      group :location
    end
  end
end
