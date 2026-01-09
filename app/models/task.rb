class Task < ApplicationRecord
  # Ruby 3.3.6 - Using pattern matching for status validations
  VALID_STATUSES = %w[pending in_progress completed rescheduled overdue]

  belongs_to :creator, class_name: "User"
  belongs_to :assignee, class_name: "User"

  validates :title, presence: true
  validates :scheduled_at, presence: true
  validates :status, inclusion: { in: VALID_STATUSES }

  scope :pending, -> { where(status: "pending") }
  scope :completed, -> { where(status: "completed") }
  scope :for_today, -> { where(scheduled_at: Time.current.all_day) }
  scope :assigned_to, ->(user) { where(assignee: user) }
  scope :created_by, ->(user) { where(creator: user) }
  scope :overdue, -> { where("scheduled_at < ? AND status != ?", Time.current, "completed") }

  # Temporarily comment out the callback until Solid Queue is set up
  after_create :schedule_reminder
  after_update :broadcast_update, if: -> { saved_change_to_status? || saved_change_to_completed_at? }

  def complete!
    update(status: "completed", completed_at: Time.current)
  end

  def reschedule_to_tomorrow!
    update(
      status: "rescheduled",
      scheduled_at: scheduled_at + 1.day,
      reminder_sent: false
    )
    # schedule_reminder # Uncomment after Solid Queue is set up
  end

  def overdue?
    scheduled_at < Time.current && status != "completed"
  end

  private

  def schedule_reminder
    # Solid Queue job
    SendReminderJob.set(wait_until: scheduled_at - 10.minutes).perform_later(id)
  end

  def broadcast_update
    # Solid Cable broadcast - only if cable is set up
    return unless defined?(Turbo)

    broadcast_replace_to "tasks_#{assignee_id}",
      partial: "tasks/task",
      locals: { task: self },
      target: "task_#{id}"
  rescue => e
    Rails.logger.error "Broadcast failed: #{e.message}"
  end
end
