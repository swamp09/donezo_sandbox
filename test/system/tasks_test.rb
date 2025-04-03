# frozen_string_literal: true

require 'application_system_test_case'

class TasksTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:alice)
    @task = tasks(:shopping)
    sign_in @user
  end

  test 'completing a task' do
    visit tasks_path

    within "##{dom_id(@task)}" do
      assert_no_text '完了済み'
      find('input[type="checkbox"]').click
      assert_text '完了済み'
    end
  end
end
