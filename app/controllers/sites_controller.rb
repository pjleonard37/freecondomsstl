class SitesController < ApplicationController

  def index

    @address = params[:address]
    
    @sites = Site.all
    
    @center_lat = @sites.first.try(:lat)
    @center_lng = @sites.first.try(:lng)

    respond_to do |format|
      format.html
      format.json { render json: @sites }
    end
  end
end
