class Capacity < ApplicationRecord
  has_many :logs, class_name: 'CapacityLog'

  def date
    reported_on
  end

  def date=(d)
    self.reported_on = d
  end
end
