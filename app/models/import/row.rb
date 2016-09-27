module Import
  class Row
    KEYS = [
      :reported_on, :in_care, :referrals, :discharges,
      :funded, :reserve, :activated, :unavailable
    ].freeze

    attr_reader :data

    def initialize(data)
      @data = data
    end

    def call
      capacity.assign_attributes(attributes)
      capacity.save
    end

    def attributes
      attrs = {}
      KEYS.each_with_index do |key, index|
        next if key == :reported_on || data[index].blank?
        attrs[key] = data[index]
      end
      attrs
    end

    def capacity
      @capacity ||= Capacity.where(date_attrs).take || Capacity.new(date_attrs)
    end

    def date_attrs
      {reported_on: Date.strptime(data.first, "%m/%d/%Y")}
    end
  end
end
