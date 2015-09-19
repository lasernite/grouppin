class WelcomeController < ApplicationController
  def index
  	# Default if no city found by geolocator - neccesary for testing/developing locally
  	if request.location.city == '' or request.location.city == nil
  		@city = 'MIT'
  	else
  		@city = request.location.city
  	end


    client = Grouppin::Application::PARSE_CLIENT
    # Upload dummy image.
    photo = client.file({
        :body => IO.read("app/assets/images/logo.gif"),
        :local_filename => "logo.gif",
        :content_type => "image/gif"
    })
    photo.save

    poster = client.object("Poster").tap do |p|
        p["image"] = photo
    end.save

    #Get all photos and store their urls in @posters
    query = client.query("Poster")

    results = query.get
    urls = []
    results.each { |x| urls.push(x["image"].url) }
    
    @posters = urls
    ### </Amin>

  end
end
