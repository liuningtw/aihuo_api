class TaskLogging < ActiveRecord::Base
  # extends ...................................................................
  # includes ..................................................................
  include CoinRule
  # relationships .............................................................
  belongs_to :task
  belongs_to :member
  # validations ...............................................................
  # TODO: 将所有金币增减相关的操作都放入 task loggins 系统中，可以追踪用户的每一笔金币记录。
  validates_uniqueness_of :task_id,
    scope: :member_id,
    message: "此任务已完成。",
    conditions: -> { where(created_at: Date.today.midnight..Date.today.end_of_day) },
    if: Proc.new { |task_logging| task_logging.task_id == Task.login_task.id }
  # callbacks .................................................................
  after_create :run_task
  # scopes ....................................................................
  # additional config (i.e. accepts_nested_attribute_for etc...) ..............
  # class methods .............................................................
  # public instance methods ...................................................
  # protected instance methods ................................................
  protected

  def run_task
    send(task.action, task.value)
  end
  # private instance methods ..................................................
end
