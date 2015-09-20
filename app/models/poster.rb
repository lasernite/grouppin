class Poster < ActiveRecord::Base
  has_attached_file :image_paperclip, styles: {
    thumb: '100x100>',
    square: '200x200#',
    medium: '300x300>',
    normal: '600x>'
  }

  # Validate the attached image is image/jpg, image/png, etc
  validates_attachment_content_type :image_paperclip, :content_type => /\Aimage\/.*\Z/

  has_many :comments
  belongs_to :user
end
