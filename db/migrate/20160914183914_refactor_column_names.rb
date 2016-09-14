class RefactorColumnNames < ActiveRecord::Migration[5.0]
  def change
    rename_column :capacities, :capacity_on, :reported_on
    rename_column :capacities, :standard, :funded
  end
end
