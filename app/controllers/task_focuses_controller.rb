# frozen_string_literal: true

class TaskFocusesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task

  def show
    @next_task = current_user.tasks.not_completed.not_in_progress.where.not(id: @task.id).order(created_at: :asc).first
    render 'tasks/focus'
  end

  private

  def set_task
    @task = current_user.tasks.find(params[:task_id])
  end
end
