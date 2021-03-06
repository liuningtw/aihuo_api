class Member < ActiveRecord::Base
  # extends ...................................................................
  # includes ..................................................................
  include CoinRule, ScoreRule, EncryptedId, HarmoniousFormatter
  # mount_uploader :avatar, AvatarUploader
  #NOTICE
  #report_num_filter字段的解释， bit位标识
  #回复屏蔽， 帖子屏蔽， 回复审核，帖子审核
  # relationships .............................................................
  has_one :device, -> { order('updated_at DESC') }, class_name: "Device"
  has_many :devices
  has_many :sended_private_messages, class_name: "PrivateMessage", foreign_key: "sender_id"
  has_many :received_private_messages, class_name: "PrivateMessage", foreign_key: "receiver_id"
  has_and_belongs_to_many :nodes, -> { uniq }
  # validations ...............................................................
  validates :nickname, presence: true, uniqueness: true, length: 2..16
  # callbacks .................................................................
  # scopes ....................................................................
  scope :by_phone, ->(phone) { where(phone: phone, verified: true) }
  scope :without_phone, ->{ where("phone is NULL") }
  # additional config (i.e. accepts_nested_attribute_for etc...) ..............
  encrypted_id key: 'uwGeTjFYo9z9NpoN'
  delegate :device_id, to: :device, allow_nil: true
  attr_reader :password

  # class methods .............................................................
  def self.encrypt_password(password, salt)
    Digest::SHA2.hexdigest(password + "yepcolor" + salt)
  end
  # public instance methods ...................................................
  def authenticate?(password)
    hashed_password == self.class.encrypt_password(password, salt)
  end

  def password=(password)
    @password = password

    if password.present?
      generate_salt
      self.hashed_password = self.class.encrypt_password(password, salt)
    end
  end

  def can_send_captcha?
    # 第一次创建的用户，发送验证码时间是空
    return true if captcha_updated_at.blank?
    # 上次发送时间在2分钟之前，并且当天发送次数在3次以内
    captcha_updated_at < Time.now.ago(120) && captcha_flag <= 4
  end

  def send_captcha(phone, app)
    return if !can_send_captcha?
    generate_captcha
    if app.name == "享爱"
      sms_sign = "享爱商城"
      ext = 1
    else
      sms_sign = "首趣商城"
      ext = 0
    end

    message = "手机验证码:#{captcha} 【#{sms_sign}】"
    ShortMessage.send_sms(phone, message, ext)
  end

  def validate_captcha?(captcha)
    self.captcha == captcha
  end

  def validate_captcha_with_phone?(captcha, phone)
    self.phone == phone && validate_captcha?(captcha) && !verified
  end

  def verified!(need_increase_coin: true)
    self.password = captcha
    self.verified = true
    # 绑定手机号增加15金币
    increase_coins(15) if need_increase_coin
    save
  end

  def verified_by_phone(phone)
    update_attributes(phone: phone, verified: true)
  end

  def relate_to_device(device_id)
    device = Device.find_by(device_id: device_id)
    device.update_column(:member_id, self.id) if device
  end

  def points_to_next_level
    maximum_points_for_level(next_level)
  end

  def next_level
    level + 1
  end

  def update_member_report_num_filter(i_report_num = 1)
    report_filter = Member.member_report_num_filter(i_report_num)
    update_columns(report_num_filter: report_filter) if report_filter > report_num_filter
  end

  def self.member_report_num_filter(i_report_num)
    if i_report_num > Setting.fetch_by_key("member_report_up_limit", "3").to_i
      Reply::FILTER + Topic::FILTER + Topic::NEED_VERTIFY
    else
      0
    end
  end

  #这里与操作，00000000001是为0不需要审核
  def topic_auto_approve?
    (report_num_filter & 1) == 0
  end

  # protected instance methods ................................................
  # private instance methods ..................................................
  private

  def generate_captcha
    self.captcha = SecureRandom.random_number.to_s[2, 6]
    set_flag
  end

  def set_flag
    self.captcha_flag = should_reset_flag? ? 0 : captcha_flag + 1
    self.captcha_updated_at = Time.now
    save
  end

  def should_reset_flag?
    return true if captcha_updated_at.blank?
    captcha_updated_at.to_date != Date.today
  end

  def generate_salt
    self.salt = SecureRandom.hex
  end
end
