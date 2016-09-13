class FormFlasher
  attr_reader :flash_object

  def initialize(flash_object, saved)
    @flash_object = flash_object
    @saved = saved
  end

  def add
    flash_object[key] = message
  end

  def key
    saved? ? :success : :error
  end

  def message
    saved? ? success_message : error_message
  end

  def success_message
    'Your changes have been saved.'
  end

  def error_message
    'There was a problem saving your changes.'
  end

  def saved?
    @saved
  end
end
