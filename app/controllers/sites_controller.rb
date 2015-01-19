class SitesController < ApplicationController

  def index

    @address = params[:address]

    @location = Geocoder.search(@address, bounds: [[39.027718840211605, -91.043701171875],
                                                   [38.268375880204744 ,-89.8187255859375]])
                .first.try(:data)

    @lng = @location.try(:[], 'geometry').try(:[], 'location').try(:[], 'lng')
    @lat = @location.try(:[], 'geometry').try(:[], 'location').try(:[], 'lat')
    
    @lng = @lng || -90
    @lat = @lat || 38
    
    @sites = Site.geo_near({ type: 'Point', coordinates: [@lng, @lat] })
             .spherical

    @distances = @sites.as_json.map { |site| site.try(:[], 'geo_near_distance') }
    @sites_with_distances = @sites.to_a.zip(@distances)
    @sites = @sites_with_distances.map do |site_with_distance|
      site = site_with_distance[0]
      distance = site_with_distance[1]
      site.distance = distance
      site
    end
    
    @center_lat = @sites.first.try(:lat)
    @center_lng = @sites.first.try(:lng)

    @formatted_address = @location.try(:[], 'formatted_address')
    
    @address = @formatted_address if @formatted_address
    
    respond_to do |format|
      format.html
      format.json { render json: @sites }
    end
  end
end
