class Event < ActiveRecord::Base
  # Hi, I'm an abstract class!

  validates_presence_of :data

  def command
    type
  end

  def data
    JSON.parse(attributes.fetch('data')).symbolize_keys
  end
end
