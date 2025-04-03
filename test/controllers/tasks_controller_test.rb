# frozen_string_literal: true

require 'test_helper'

class TasksControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:alice)
    sign_in @user
  end

  test 'should get index' do
    get tasks_url
    assert_response :success
  end
end
