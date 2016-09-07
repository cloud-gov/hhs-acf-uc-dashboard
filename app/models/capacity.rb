class Capacity < ApplicationRecord
  has_many :logs, class_name: 'CapacityLog'

  def date
    capacity_on
  end

  def date=(d)
    self.capacity_on = d
  end
end
