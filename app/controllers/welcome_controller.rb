class WelcomeController < ApplicationController
  def index
  	# Default if no city found by geolocator - neccesary for testing/developing locally
  	if request.location.city == '' or request.location.city == nil
  		@city = 'MIT'
  	else
  		@city = request.location.city
  	end
  end
end
