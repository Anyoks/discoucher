require 'test_helper'

class RegisterBooksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @register_book = register_books(:one)
  end

  test "should get index" do
    get register_books_url
    assert_response :success
  end

  test "should get new" do
    get new_register_book_url
    assert_response :success
  end

  test "should create register_book" do
    assert_difference('RegisterBook.count') do
      post register_books_url, params: { register_book: { book_code: @register_book.book_code, email: @register_book.email, first_name: @register_book.first_name, last_name: @register_book.last_name, phone_number: @register_book.phone_number } }
    end

    assert_redirected_to register_book_url(RegisterBook.last)
  end

  test "should show register_book" do
    get register_book_url(@register_book)
    assert_response :success
  end

  test "should get edit" do
    get edit_register_book_url(@register_book)
    assert_response :success
  end

  test "should update register_book" do
    patch register_book_url(@register_book), params: { register_book: { book_code: @register_book.book_code, email: @register_book.email, first_name: @register_book.first_name, last_name: @register_book.last_name, phone_number: @register_book.phone_number } }
    assert_redirected_to register_book_url(@register_book)
  end

  test "should destroy register_book" do
    assert_difference('RegisterBook.count', -1) do
      delete register_book_url(@register_book)
    end

    assert_redirected_to register_books_url
  end
end
