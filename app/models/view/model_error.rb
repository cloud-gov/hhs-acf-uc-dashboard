module View
  class ModelError < Struct.new(:model, :heading)
    def errors?
      !model.errors.empty?
    end

    def messages
      model.errors.full_messages
    end
  end
end
