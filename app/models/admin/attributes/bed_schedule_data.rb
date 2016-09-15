module Admin
  module Attributes
    class BedScheduleData
      attr_reader :params

      def initialize(params)
        @params = params
      end

      def valid?
        date_valid? && bed_count_valid?
      end

      def validation_errors
        date_errors + bed_count_errors
      end

      def bed_count
        params[:bed_count].to_i
      end

      def scheduled_on
        parse_date
      rescue ArgumentError
        nil
      end

      def base_attributes
        {
          facility_name: params[:facility_name],
          bed_count: bed_count,
          scheduled_on: scheduled_on,
          month: month,
          day: day,
          year: year
        }
      end

      def new_attributes
        base_attributes.merge({
          current: true
        })
      end

      def update_attributes
        base_attributes.merge({
          current: current
        })
      end

      def month
        params[:month]
      end

      def day
        params[:day]
      end

      def year
        params[:year]
      end

      private

      def current
        params[:delete].to_i != 1
      end

      def bed_count_valid?
        bed_count >= 0 &&
          bed_count.to_s == params[:bed_count].strip
      end

      def date_valid?
        true if parse_date
      rescue ArgumentError
        false
      end

      def parse_date
        Date.parse("#{year}-#{month}-#{day}")
      end

      def date_errors
        return [] if date_valid?
        [ValidationError.new(:scheduled_date, 'is not valid')]
      end

      def bed_count_errors
        return [] if bed_count_valid?
        [ValidationError.new(:bed_count, 'not valid. Please enter a positive, whole number')]
      end
    end
  end
end
