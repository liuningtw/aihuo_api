class Orderlog < ActiveRecord::Base
  # extends ...................................................................
  # includes ..................................................................
  # security (i.e. attr_accessible) ...........................................
  # relationships .............................................................
  # validations ...............................................................
  # callbacks .................................................................
  # scopes ....................................................................
  # additional config .........................................................
  # class methods .............................................................
  def self.logging_action(method, user)
    create({ content: "Device ID: #{user} 刪除了订单。"}) if method.to_sym == :delete
  end
  # public instance methods ...................................................
  # protected instance methods ................................................
  # private instance methods ..................................................
end