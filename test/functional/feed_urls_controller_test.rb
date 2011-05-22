require 'test_helper'

class FeedUrlsControllerTest < ActionController::TestCase
  setup do
    @feed_url = feed_urls(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:feed_urls)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create feed_url" do
    assert_difference('FeedUrl.count') do
      post :create, feed_url: @feed_url.attributes
    end

    assert_redirected_to feed_url_path(assigns(:feed_url))
  end

  test "should show feed_url" do
    get :show, id: @feed_url.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @feed_url.to_param
    assert_response :success
  end

  test "should update feed_url" do
    put :update, id: @feed_url.to_param, feed_url: @feed_url.attributes
    assert_redirected_to feed_url_path(assigns(:feed_url))
  end

  test "should destroy feed_url" do
    assert_difference('FeedUrl.count', -1) do
      delete :destroy, id: @feed_url.to_param
    end

    assert_redirected_to feed_urls_path
  end
end
