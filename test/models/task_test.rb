# frozen_string_literal: true

require 'test_helper'

class TaskTest < ActiveSupport::TestCase
  # タスクを実行中にするテスト
  test 'start_task should set the task as in progress' do
    task = tasks(:shopping)
    task.start_task

    assert task.in_progress?
    assert_not task.completed?
    assert_not_nil task.started_at
  end

  test 'start_task should stop other in-progress tasks of the same user' do
    # 同じユーザー(alice)の最初のタスクを実行中にする
    first_task = tasks(:shopping)
    first_task.update(in_progress: true)
    assert first_task.in_progress?

    # 同じユーザー(alice)の別のタスクを実行中にする
    second_task = tasks(:study)
    second_task.update(completed: false) # 完了状態を解除
    second_task.start_task

    # 最初のタスクが停止されていることを確認
    first_task.reload
    assert_not first_task.in_progress?

    # 2番目のタスクが実行中であることを確認
    assert second_task.in_progress?
  end

  test 'start_task should not stop in-progress tasks of other users' do
    # あるユーザー(bob)のタスクを実行中にする
    bob_task = tasks(:meeting)
    bob_task.update(in_progress: true)
    assert bob_task.in_progress?

    # 別のユーザー(alice)のタスクを実行中にする
    alice_task = tasks(:shopping)
    alice_task.start_task

    # bobのタスクはまだ実行中であることを確認
    bob_task.reload
    assert bob_task.in_progress?

    # aliceのタスクも実行中であることを確認
    assert alice_task.in_progress?
  end

  test 'start_task should set started_at to current time' do
    task = tasks(:shopping)

    # 現在時刻の前後で比較するために、実行前の時刻を記録
    before_time = Time.current
    task.start_task
    after_time = Time.current

    # started_atが現在時刻の範囲内にあることを確認
    assert task.started_at >= before_time
    assert task.started_at <= after_time
  end

  test 'start_task should set completed to false' do
    # 完了済みのタスクを使用
    task = tasks(:study)
    assert task.completed?

    # タスクを実行中にする
    task.start_task

    # 完了フラグがfalseになっていることを確認
    assert_not task.completed?
  end
end

test 'stop_task should set the task as not in progress' do
  task = tasks(:shopping)
  task.update(in_progress: true, started_at: Time.current)

  task.stop_task

  assert_not task.in_progress?
end

test 'stop_task should update elapsed_time correctly' do
  task = tasks(:shopping)
  initial_elapsed_time = 120 # 2 minutes
  task.update(in_progress: true, started_at: 2.minutes.ago, elapsed_time: initial_elapsed_time)

  task.stop_task

  assert_equal initial_elapsed_time + 120, task.elapsed_time
end

test 'stop_task should not update elapsed_time if task is not in progress' do
  task = tasks(:shopping)
  initial_elapsed_time = 300 # 5 minutes
  task.update(in_progress: false, elapsed_time: initial_elapsed_time)

  task.stop_task

  assert_equal initial_elapsed_time, task.elapsed_time
end

test 'stop_task should handle nil started_at gracefully' do
  task = tasks(:shopping)
  task.update(in_progress: true, started_at: nil, elapsed_time: 0)

  task.stop_task

  assert_not task.in_progress?
  assert_equal 0, task.elapsed_time
end
