class TesseractInformationController < ApplicationController
  skip_before_filter :verify_authenticity_token 
  def index
  	e = Grouppin::Application::ENGINE
  	@text = e.lines_for('app/assets/images/test_image.jpg')
  end
end
