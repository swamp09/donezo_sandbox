# frozen_string_literal: true

class AddInProgressToTasks < ActiveRecord::Migration[8.0]
  def change
    add_column :tasks, :in_progress, :boolean, default: false
    add_column :tasks, :started_at, :datetime
    add_column :tasks, :elapsed_time, :integer, default: 0
  end
end
