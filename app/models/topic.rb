class Topic < ActiveRecord::Base
  # extends ...................................................................
  acts_as_paranoid
  # includes ..................................................................
  include EncryptedId
  include ForumValidations
  include Voting
  include HarmoniousFormatter
  # relationships .............................................................
  belongs_to :node, :counter_cache => true
  belongs_to :member
  has_many :replies, -> { order "created_at DESC" }, as: :replyable, :dependent => :destroy
  has_many :favorites, as: :favable
  # validations ...............................................................
  validates_uniqueness_of :body, :scope => :device_id, :message => "请勿重复发言"
  # callbacks .................................................................
  after_initialize :set_approved_status
  # scopes ....................................................................
  default_scope { order("updated_at DESC") }
  scope :approved, -> { where(approved: true) }
  scope :by_device, ->(device_id) { where(device_id: device_id) }
  scope :popular, -> { where("replies_count >= 50") }
  scope :newly, -> { where(best: false).reorder("top DESC, created_at DESC") }
  scope :latest, -> { where(best: false).reorder("top DESC, updated_at DESC") }
  scope :excellent, -> { where(best: true).reorder("bested_at DESC, updated_at DESC") }
  scope :recommend, -> { where(recommend: true, top: false).reorder("created_at DESC") }
  scope :checking, -> { where(approved: false) }
  scope :favorites_by_device, ->(device_id) {
    joins(:favorites).where(favorites: { device_id: device_id })
  }
  # additional config (i.e. accepts_nested_attribute_for etc...) ..............
  encrypted_id key: '36aAoQHCaJKETWHR'
  # class methods .............................................................
  def self.scope_by_filter(filter, device_id = nil)
    case filter
    when :recommend
      approved.recommend
    when :best
      approved.excellent
    when :checking
      checking
    when :hot
      approved.latest
    when :new
      approved.newly
    when :mine
      with_deleted.by_device(device_id)
    when :followed
      favorites_by_device(device_id)
    when :all
      self
    end
  end
  # public instance methods ...................................................
  # User is a device id.
  def destroy_by(user)
    if user == device_id
      # 帖主本人删除, member id 123510 named "匿名"
      update_attributes({ device_id: nil, nickname: "匿名", member_id: 123510 })
    else
      update_attribute(:deleted_by, user) # 管理员删除
      destroy
    end
  end

  def relate_to_member_with_authenticate(member_id, password)
    member = Member.find(member_id) if member_id
    self.member = member if member && member.authenticate?(password)
  end

  # protected instance methods ................................................
  # private instance methods ..................................................
  private

  def set_approved_status
    self.approved = false if new_record?
  end
end
