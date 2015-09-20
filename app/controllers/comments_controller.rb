class CommentsController < ApplicationControllerc
  def create
    @poster = Poster.find(params[:poster_id])
    @comment = @poster.comments.create(params[:comment])
    redirect_to '/'
  end
end
