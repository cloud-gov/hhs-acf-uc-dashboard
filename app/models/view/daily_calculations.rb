module View
  class DailyCalculations
    attr_reader :data

    def initialize(data)
      @data = data
    end

    def open_beds
      data.funded + data.activated - data.in_care
    end

    def current_funded_capacity
      data.funded + data.activated
    end

    def total_reserve_capacity
      current_funded_capacity + data.reserve
    end

    def activated_rate
      RatioPresenter.new(activation_ratio).percentage
    end

    def activated_rate_status
      RatioPresenter.new(activation_ratio).alert_status
    end

    def reserved_rate
      RatioPresenter.new(reserved_ratio).percentage
    end

    def reserved_rate_status
      RatioPresenter.new(reserved_ratio).alert_status
    end

    def funded_percentage_status
      RatioPresenter.new(funded_ratio).alert_status
    end

    def funded_percentage
      RatioPresenter.new(funded_ratio).percentage
    end

    def funded_available_percentage_status
      RatioPresenter.new(funded_available_ratio).alert_status
    end

    def funded_available_percentage
      RatioPresenter.new(funded_available_ratio).percentage
    end

    private

    def reserved_ratio
      data.in_care.to_f/(data.funded + data.reserve + data.activated)
    end

    def activation_ratio
      data.in_care.to_f/(data.funded + data.activated)
    end

    def funded_ratio
      data.in_care.to_f/data.funded
    end

    def funded_available_ratio
      data.in_care.to_f/(data.funded - data.unavailable)
    end
  end
end
