class PostersController < ApplicationController
	def create
		@poster = Poster.new(poster_params)
		@poster.save
	end


	private
	    def poster_params
	  	  params.require(:poster).permit(:image_url, :image_paperclip, :love, :comments, :tesseract_text, :parsed_minute, :parsed_hour, :parsed_day_of_week, :parsed_day_of_month, :parsed_month)
	    end
end
