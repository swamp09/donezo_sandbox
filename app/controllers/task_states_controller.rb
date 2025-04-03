# frozen_string_literal: true

class TaskStatesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task

  def update
    case params[:state]
    when 'in_progress'
      @task.start_task
    when 'stopped'
      @task.stop_task
    when 'completed'
      @task.complete_task
    end

    render turbo_stream: [
      turbo_stream.replace(resource_dom_id(@task), partial: 'tasks/task', locals: { task: @task }),
      turbo_stream.replace('tasks_header', partial: 'tasks/header', locals: { tasks: current_user.tasks })
    ]
  end

  private

  def set_task
    @task = current_user.tasks.find(params[:task_id])
  end
end
