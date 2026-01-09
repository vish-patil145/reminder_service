class SendReminderJob < ApplicationJob
  queue_as :default

  def perform(task_id)
    task = Task.find_by(id: task_id)
    return unless task && !task.reminder_sent && task.status == "pending"

    # Send notification (email, SMS, push notification, etc.)
    ReminderMailer.task_reminder(task).deliver_now

    # Mark reminder as sent
    task.update(reminder_sent: true)

    # Broadcast real-time notification via Solid Cable
    broadcast_notification(task)
  end

  private

  def broadcast_notification(task)
    Turbo::StreamsChannel.broadcast_append_to(
      "user_#{task.assignee_id}_notifications",
      target: "notifications",
      partial: "notifications/reminder",
      locals: { task: task }
    )
  end
end
