class WelcomeController < ApplicationController
	def index
		# Default if no city found by geolocator - neccesary for testing/developing locally
		if request.location.city == '' or request.location.city == nil
			@city = 'MIT'
		else
			@city = request.location.city
		end

		# Devise current user from session
		@user = current_user

        # allow poster form
        @new_poster = Poster.new

        @posters = Poster.all

		@sorted = @posters.sort_by {|p| p.parsed_datetime}
	end
end
