class AddDateTimeToPosters < ActiveRecord::Migration
    def self.up
      add_column :posters, :parsed_datetime, :datetime
    end

    def self.down
      remove_column :posters, :parsed_date_time, :time
    end
end
