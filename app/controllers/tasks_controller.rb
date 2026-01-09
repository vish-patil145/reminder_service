class TasksController < ApplicationController
  before_action :require_authentication
  before_action :set_task, only: [ :show, :edit, :update, :destroy, :complete, :reschedule ]

  def index
    # Using Solid Cache
    @my_tasks = Rails.cache.fetch("user_#{current_user.id}_tasks", expires_in: 5.minutes) do
      current_user.assigned_tasks
        .includes(:creator)
        .order(scheduled_at: :asc)
        .to_a
    end

    @created_tasks = current_user.created_tasks
      .where.not(assignee: current_user)
      .includes(:assignee)
      .order(scheduled_at: :asc)
  end

  def show
    # Show individual task details
  end

  def dashboard
    @today_tasks = current_user.assigned_tasks.for_today.pending
    @overdue_tasks = current_user.assigned_tasks.overdue
    @completed_today = current_user.assigned_tasks.for_today.completed

    # Ruby 3.3.6 - Pattern matching example
    @task_stats = calculate_stats
  end

  def new
    @task = Task.new
    @users = User.all
  end

  def create
    @task = current_user.created_tasks.build(task_params)

    if @task.save
      clear_cache
      redirect_to tasks_path, notice: "Task created successfully!"
    else
      @users = User.all
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @users = User.all
  end

  def update
    if @task.update(task_params)
      clear_cache
      redirect_to tasks_path, notice: "Task updated successfully!"
    else
      @users = User.all
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    clear_cache
    redirect_to tasks_path, notice: "Task deleted successfully!"
  end

  def complete
    @task.complete!
    clear_cache
    respond_to do |format|
      format.html { redirect_to tasks_path, notice: "Task completed!" }
      format.turbo_stream
    end
  end

  def reschedule
    @task.reschedule_to_tomorrow!
    clear_cache
    respond_to do |format|
      format.html { redirect_to tasks_path, notice: "Task rescheduled to tomorrow!" }
      format.turbo_stream
    end
  end

  private

  def set_task
    @task = Task.find(params[:id])
    authorize_task_access!
  end

  def authorize_task_access!
    unless @task.creator == current_user || @task.assignee == current_user
      redirect_to tasks_path, alert: "Access denied"
    end
  end

  def task_params
    params.require(:task).permit(:title, :description, :scheduled_at, :assignee_id)
  end

  def clear_cache
    Rails.cache.delete("user_#{current_user.id}_tasks")
    Rails.cache.delete("user_#{@task.assignee_id}_tasks") if @task
  end

  # Ruby 3.3.6 pattern matching
  def calculate_stats
    tasks = current_user.assigned_tasks

    case [ tasks.pending.count, tasks.completed.count ]
    in [ 0, 0 ]
      { message: "No tasks yet!", status: :empty }
    in [ pending, 0 ] if pending > 5
      { message: "You have #{pending} pending tasks!", status: :busy }
    in [ pending, completed ] if completed > pending
      { message: "Great progress! #{completed} completed!", status: :productive }
    else
      { message: "Keep going!", status: :normal }
    end
  end
end
