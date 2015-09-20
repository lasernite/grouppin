class AddParsedDateTimeToPosters < ActiveRecord::Migration
  def change
  	add_column :posters, :parsed_date_time, :time
  end
end
