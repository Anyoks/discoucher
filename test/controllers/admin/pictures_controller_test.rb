require 'test_helper'

class Admin::PicturesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_picture = admin_pictures(:one)
  end

  test "should get index" do
    get admin_pictures_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_picture_url
    assert_response :success
  end

  test "should create admin_picture" do
    assert_difference('Admin::Picture.count') do
      post admin_pictures_url, params: { admin_picture: {  } }
    end

    assert_redirected_to admin_picture_url(Admin::Picture.last)
  end

  test "should show admin_picture" do
    get admin_picture_url(@admin_picture)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_picture_url(@admin_picture)
    assert_response :success
  end

  test "should update admin_picture" do
    patch admin_picture_url(@admin_picture), params: { admin_picture: {  } }
    assert_redirected_to admin_picture_url(@admin_picture)
  end

  test "should destroy admin_picture" do
    assert_difference('Admin::Picture.count', -1) do
      delete admin_picture_url(@admin_picture)
    end

    assert_redirected_to admin_pictures_url
  end
end
