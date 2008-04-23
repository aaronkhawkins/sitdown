require File.dirname(__FILE__) + '/../test_helper'

class AchievementsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:achievements)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_achievement
    assert_difference('Achievement.count') do
      post :create, :achievement => { }
    end

    assert_redirected_to achievement_path(assigns(:achievement))
  end

  def test_should_show_achievement
    get :show, :id => achievements(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => achievements(:one).id
    assert_response :success
  end

  def test_should_update_achievement
    put :update, :id => achievements(:one).id, :achievement => { }
    assert_redirected_to achievement_path(assigns(:achievement))
  end

  def test_should_destroy_achievement
    assert_difference('Achievement.count', -1) do
      delete :destroy, :id => achievements(:one).id
    end

    assert_redirected_to achievements_path
  end
end
