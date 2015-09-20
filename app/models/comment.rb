class Comment < ActiveRecord::Base
	# attr_accesssible :body, :commenter, :poster
  
  	belongs_to :poster
end
