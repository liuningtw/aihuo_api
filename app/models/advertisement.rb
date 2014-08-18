class Advertisement < ActiveRecord::Base
  # extends ...................................................................
  # includes ..................................................................
  include CarrierWave
  # relationships .............................................................
  has_many :adv_statistics, foreign_key: "adv_content_id"
  # validations ...............................................................
  # callbacks .................................................................
  # scopes ....................................................................
  # default_scope {
  #   where(activity: true).where("today_view_count < actual_view_count")
  #     .order("updated_at DESC")
  # }
  scope :available, -> {
    joins(:adv_statistics).merge(AdvStatistic.today)
      .where(activity: true)
      .where("adv_statistics.install_count < adv_contents.plan_view_count")
      .order("updated_at DESC")
  }
  # additional config (i.e. accepts_nested_attribute_for etc...) ..............
  self.table_name = "adv_contents"
  # class methods .............................................................
  def self.increase_view_count
    all.map(&:increase_view_count)
  end

  def increase_view_count
    update_columns({
      today_view_count: today_view_count + 1,
      total_view_count: total_view_count + 1
    })
  end

  # public instance methods ...................................................
  # protected instance methods ................................................
  # private instance methods ..................................................
end
