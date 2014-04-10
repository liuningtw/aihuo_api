class Reply < ActiveRecord::Base
  # extends ...................................................................
  encrypted_id key: 'vfKYGu3kbQ3skEWr'
  # includes ..................................................................
  include ForumValidations
  # relationships .............................................................
  belongs_to :topic, :counter_cache => true, :touch => true
  delegate :node, to: :topic
  delegate :node_id, to: :topic
  # validations ...............................................................
  validates_uniqueness_of :body, :scope => [:topic_id, :device_id], :message => "请勿重复发言"
  # callbacks .................................................................
  # scopes ....................................................................
  default_scope { order("created_at DESC") }
  # additional config (i.e. accepts_nested_attribute_for etc...) ..............
  # class methods .............................................................
  # public instance methods ...................................................
  # protected instance methods ................................................
  # private instance methods ..................................................
end