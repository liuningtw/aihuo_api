class Coupon < ActiveRecord::Base
  # extends ...................................................................
  # includes ..................................................................
  include EncryptedId
  # relationships .............................................................
  has_and_belongs_to_many :orders
  # validations ...............................................................
  # callbacks .................................................................
  # scopes ....................................................................
  scope :by_device, ->(device_id) { where(:to => [device_id, 'ALL']) }
  scope :enabled, -> { where(enabled: true) }
  scope :separate, -> { where(separate: true) }
  scope :available, -> {
    enabled.where("start_time <= ? AND end_time >= ?", Time.now, Time.now)
  }
  scope :by_sdk_ver, ->(ver) {
    ver ? where("application_ver <= ?", ver) : Coupon.where(application_id: nil)
  }
  # additional config (i.e. accepts_nested_attribute_for etc...) ..............
  encrypted_id key: 'pVXy9ChXEe2Fmmfa'
  # class methods .............................................................
  def used!
    new_number = number - 1
    new_number = new_number < 0 ? 0 : new_number
    update_attribute(:number, new_number)
    update_attribute(:enabled, false) if new_number == 0
  end
  # public instance methods ...................................................
  # protected instance methods ................................................
  # private instance methods ..................................................
end
