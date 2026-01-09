module TasksHelper
  def status_badge_class(task)
    case task.status
    when "completed"
      "bg-teal-100 text-teal-700 border-2 border-teal-300"
    when "pending"
      task.overdue? ? "bg-red-100 text-red-700 border-2 border-red-300" : "bg-yellow-100 text-yellow-700 border-2 border-yellow-300"
    when "overdue"
      "bg-red-100 text-red-700 border-2 border-red-300"
    when "rescheduled"
      "bg-purple-100 text-purple-700 border-2 border-purple-300"
    else
      "bg-gray-100 text-gray-700 border-2 border-gray-300"
    end
  end

  def status_icon(task)
    case task.status
    when "completed"
      "✅"
    when "pending"
      task.overdue? ? "⚠️" : "⏳"
    when "overdue"
      "⚠️"
    when "rescheduled"
      "🔄"
    else
      "📌"
    end
  end
end
