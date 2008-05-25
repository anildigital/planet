require File.dirname(__FILE__) + '/../test_helper'

class FeedUrlsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:feed_urls)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_feed_url
    assert_difference('FeedUrl.count') do
      post :create, :feed_url => { }
    end

    assert_redirected_to feed_url_path(assigns(:feed_url))
  end

  def test_should_show_feed_url
    get :show, :id => feed_urls(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => feed_urls(:one).id
    assert_response :success
  end

  def test_should_update_feed_url
    put :update, :id => feed_urls(:one).id, :feed_url => { }
    assert_redirected_to feed_url_path(assigns(:feed_url))
  end

  def test_should_destroy_feed_url
    assert_difference('FeedUrl.count', -1) do
      delete :destroy, :id => feed_urls(:one).id
    end

    assert_redirected_to feed_urls_path
  end
end
