class AddImagePaperclipToPoster < ActiveRecord::Migration
  def self.up
    add_attachment :posters, :image_paperclip
  end

  def self.down
    remove_attachment :posters, :image_paperclip
  end
end
