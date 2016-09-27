class CacheStats < ActiveRecord::Migration[5.0]
  def change
    add_column :capacities, :in_care, :integer
    add_column :capacities, :referrals, :integer
    add_column :capacities, :discharges, :integer
  end
end
