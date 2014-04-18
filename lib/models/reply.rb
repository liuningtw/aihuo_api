class Reply < ActiveRecord::Base
  # extends ...................................................................
  encrypted_id key: 'vfKYGu3kbQ3skEWr'
  # includes ..................................................................
  include ForumValidations
  # relationships .............................................................
  belongs_to :replyable, polymorphic: true
  belongs_to :topic, foreign_key: 'replyable_id', counter_cache: true, touch: true
  belongs_to :member
  has_many :replies, as: :replyable
  delegate :node, to: :topic, allow_nil: true
  delegate :node_id, to: :topic, allow_nil: true
  # validations ...............................................................
  validates_uniqueness_of :body,
    :scope => [:replyable_id, :replyable_type, :device_id],
    :message => "请勿重复发言"
  # callbacks .................................................................
  # scopes ....................................................................
  default_scope { order("created_at DESC") }
  # additional config (i.e. accepts_nested_attribute_for etc...) ..............
  # class methods .............................................................
  # public instance methods ...................................................
  def relate_to_member_with_authenticate(member_id, password)
    member = Member.find(member_id) if member_id
    self.member = member if member && member.authenticate?(password)
  end
  # protected instance methods ................................................
  # private instance methods ..................................................
end
