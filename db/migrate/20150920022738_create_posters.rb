class CreatePosters < ActiveRecord::Migration
  def change
    create_table :posters do |t|
      t.text :image_url
      t.integer :love
      t.text :comments
      t.text :tesseract_text
      t.integer :parsed_minute
      t.integer :parsed_hour
      t.string :parsed_day_of_week
      t.integer :parsed_day_of_month
      t.integer :parsed_month

      t.timestamps
    end
  end
end
