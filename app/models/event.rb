class Event < ActiveRecord::Base
  # Hi, I'm an abstract class!

  validates_presence_of :data

  scope :ordered, -> { order(:created_at) }

  def process!
    return unless self.valid?
    apply
    self.save!
  end

  def command
    type
  end

  # TODO: we could make a before_action that converts
  # a hash to JSON for storage, and maybe the other way
  # for initialization
  def data
    JSON.parse(attributes.fetch('data')).symbolize_keys
  end
end
