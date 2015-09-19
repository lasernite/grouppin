class UsersController < ApplicationController
	# Authenticate that user is signed in
	before_action :authenticate_user!
end
