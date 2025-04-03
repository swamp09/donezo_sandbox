# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :user, optional: true

  # タスクの状態を管理するスコープ
  scope :in_progress, -> { where(in_progress: true) }
  scope :not_in_progress, -> { where(in_progress: false) }
  scope :completed, -> { where(completed: true) }
  scope :not_completed, -> { where(completed: false) }

  # タスクを実行中にする
  def start_task
    # 他の実行中タスクがあれば停止する
    Task.in_progress.where.not(id: id).update_all(in_progress: false)

    update(
      in_progress: true,
      started_at: Time.current,
      completed: false
    )
  end

  # タスクを停止する
  def stop_task
    return unless in_progress?

    # 経過時間を更新
    current_elapsed_time = elapsed_time || 0
    time_diff = Time.current - (started_at || Time.current)

    update(
      in_progress: false,
      elapsed_time: current_elapsed_time + time_diff.to_i
    )
  end

  # タスクを完了する
  def complete_task
    stop_task if in_progress?
    update(completed: true, in_progress: false)
  end

  # タスクをリセットする
  def reset_task
    update(
      in_progress: false,
      completed: false,
      started_at: nil,
      elapsed_time: 0
    )
  end

  # 経過時間を人間が読める形式で返す
  def formatted_elapsed_time
    total_seconds = elapsed_time || 0

    if in_progress? && started_at.present?
      total_seconds += (Time.current - started_at).to_i
    end

    hours = total_seconds / 3600
    minutes = (total_seconds % 3600) / 60
    seconds = total_seconds % 60

    if hours > 0
      format('%<hours>d:%<minutes>02d:%<seconds>02d', hours: hours, minutes: minutes, seconds: seconds)
    else
      format('%<minutes>02d:%<seconds>02d', minutes: minutes, seconds: seconds)
    end
  end
end
