class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: [:update, :destroy]

  def index
    @tasks = current_user.tasks.order(created_at: :desc)
  end

  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      @tasks = current_user.tasks.order(created_at: :desc)
      render turbo_stream: [
        turbo_stream.replace('tasks', partial: 'tasks/tasks', locals: { tasks: @tasks }),
        turbo_stream.replace('task_form', partial: 'tasks/form')
      ]
    else
      render :index, status: :unprocessable_entity
    end
  end

  def update
    @task.update(task_params)
    render turbo_stream: turbo_stream.replace(resource_dom_id(@task), partial: 'tasks/task', locals: { task: @task })
  end

  def destroy
    task_id = resource_dom_id(@task)
    @task.destroy
    render turbo_stream: turbo_stream.remove(task_id)
  end

  private

  def set_task
    @task = current_user.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :completed)
  end
end
