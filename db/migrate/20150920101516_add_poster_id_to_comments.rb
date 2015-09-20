class AddPosterIdToComments < ActiveRecord::Migration
  def change
  	add_column :comments, :poster_id, :integer
  end
end
