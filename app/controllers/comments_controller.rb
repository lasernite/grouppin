class CommentsController < ApplicationController
  def create
    @poster = Poster.find(params[:poster_id])
    @comment = @poster.comments.create(comment_params)
    @comment['user_id'] = current_user.id
    @comment.save
    redirect_to '/'
  end

  	private
	    def comment_params
	  	  params.require(:comment).permit(:body, :commenter, :poster, :user_id)
	    end
end
