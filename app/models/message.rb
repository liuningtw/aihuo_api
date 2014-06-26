class Message < ActiveRecord::Base
  # extends ...................................................................
  # includes ..................................................................
  include EncryptedId
  # relationships .............................................................
  # validations ...............................................................
  # callbacks .................................................................
  # scopes ....................................................................
  scope :question, -> { where(:category => "question") }
  scope :by_device, ->(device_id) {
    where("q_messages.from = ? OR q_messages.to = ?", device_id, device_id)
  }
  scope :since, ->(id) {
    # TODO: test how about id is nil or blank.
    where("q_messages.id > ?", Message.decrypt(Message.encrypted_id_key, id)) if id
  }
  # additional config (i.e. accepts_nested_attribute_for etc...) ..............
  encrypted_id key: '9dQQjevhdWx4BwxV'
  self.table_name = "q_messages"
  # class methods .............................................................
  # public instance methods ...................................................
  def question_id
    Message.encrypt(Message.encrypted_id_key, parent_id)
  end

  def product_id
    Product.encrypt(Product.encrypted_id_key, object_id)
  end
  # protected instance methods ................................................
  # private instance methods ..................................................
end