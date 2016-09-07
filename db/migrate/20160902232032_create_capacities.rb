class CreateCapacities < ActiveRecord::Migration[5.0]
  def change
    # Capacities is a weird concept and these are really repeating fields
    # as shown, but the underlying data concepts are worse. Each facility
    # should have capacity numbers (as a separate table instead of repeating
    # fields), but that isn't ready yet.
    create_table :capacities do |t|
      t.date :capacity_on
      t.integer :standard
      t.integer :reserve
      t.integer :activated
      t.integer :unavailable
      t.string :status
      t.timestamps
    end

    create_table :capacity_logs do |t|
      t.integer :capacity_id
      t.integer :user_id
      t.string  :message
      t.timestamps
    end

    add_index :capacities, :capacity_on, unique: true
    add_index :capacity_logs, :capacity_id
  end
end
