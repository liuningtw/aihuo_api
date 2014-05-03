class PrivateMessage < ActiveRecord::Base
  # extends ...................................................................
  encrypted_id key: 'GZp4TPUCFsgzu7Jr'
  # includes ..................................................................
  include CoinRule
  # relationships .............................................................
  belongs_to :sender, class_name: "Member", foreign_key: "sender_id"
  belongs_to :receiver, class_name: "Member", foreign_key: "receiver_id"
  # validations ...............................................................
  # callbacks .................................................................
  after_create :send_notice_msg
  after_create :reduce_coin
  # scopes ....................................................................
  default_scope { where(spam: false).order("created_at DESC") }
  scope :spam, -> { where(spam: true) }
  scope :by_receiver, ->(member_id) { where(receiver_id: member_id) }
  scope :history, ->(member_id, friend_id) {
    condition = [
        "(receiver_id = ? AND sender_id = ?)",
        "(receiver_id = ? AND sender_id = ?)"
      ].join(" OR ")
    where(condition, member_id, friend_id, friend_id, member_id)
  }
  # additional config (i.e. accepts_nested_attribute_for etc...) ..............
  delegate :device_id, to: :receiver, allow_nil: true
  # class methods .............................................................
  # public instance methods ...................................................
  def friendly_to_receiver?
    !PrivateMessage.where(sender_id: receiver_id, receiver_id: sender_id).count.zero?
  end

  def opened!
    update_column(:opened, true)
  end
  # protected instance methods ................................................
  # private instance methods ..................................................
  private

  # 创建小纸条给用户发送消息
  def send_notice_msg
    # 用户拒收通知
    if receiver.receive_message_notification?
      Notification.send_private_message_msg(device_id)
    end
  end

  def reduce_coin
    unless self.friendly_to_receiver?
      # 陌生的两个人首次发送一条小纸条扣5金币
      reduce(5)
    end
  end
end
