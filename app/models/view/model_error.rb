module View
  class ModelError
    attr_reader :model

    def initialize(model, heading)
      @model = model
      @heading = heading
    end

    def heading
      @heading || 'Some of your data was invalid'
    end

    def errors?
      !model.errors.empty?
    end

    def messages
      model.errors.full_messages
    end
  end
end
