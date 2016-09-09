class CreateBedSchedules < ActiveRecord::Migration[5.0]
  def change
    # 2 things!
    # 1/ This data sucks. It should be really relational with full facility
    # management. This is a stop gap to get the dashboard working.
    # 2/ This data should be in the API once it does not suck!
    create_table :bed_schedules do |t|
      t.string :facility_name
      t.integer :bed_count
      t.date :scheduled_on
      t.boolean :current
      t.timestamps
    end

    add_index :bed_schedules, :current
  end
end
