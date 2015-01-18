class SiteSerializer < ApplicationSerializer
  attributes :name, :street, :city, :state, :zip,
             :geo_location, :hours, :distribution_method,
             :distribution_frequency, :populations

  def city
    object.city.try(:name)
  end

  def state
    object.state.try(:name)
  end

  def zip
    object.zip.try(:code)
  end

  def populations
    object.populations.map(&:name)
  end
end
