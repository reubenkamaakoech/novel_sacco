require "test_helper"

class ClosingBooksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @closing_book = closing_books(:one)
  end

  test "should get index" do
    get closing_books_url
    assert_response :success
  end

  test "should get new" do
    get new_closing_book_url
    assert_response :success
  end

  test "should create closing_book" do
    assert_difference("ClosingBook.count") do
      post closing_books_url, params: { closing_book: { amount_paid: @closing_book.amount_paid, closing_date: @closing_book.closing_date, member_id: @closing_book.member_id, other_charges: @closing_book.other_charges, remarks: @closing_book.remarks, total_savings: @closing_book.total_savings, user_id: @closing_book.user_id, withdrawal_charges: @closing_book.withdrawal_charges } }
    end

    assert_redirected_to closing_book_url(ClosingBook.last)
  end

  test "should show closing_book" do
    get closing_book_url(@closing_book)
    assert_response :success
  end

  test "should get edit" do
    get edit_closing_book_url(@closing_book)
    assert_response :success
  end

  test "should update closing_book" do
    patch closing_book_url(@closing_book), params: { closing_book: { amount_paid: @closing_book.amount_paid, closing_date: @closing_book.closing_date, member_id: @closing_book.member_id, other_charges: @closing_book.other_charges, remarks: @closing_book.remarks, total_savings: @closing_book.total_savings, user_id: @closing_book.user_id, withdrawal_charges: @closing_book.withdrawal_charges } }
    assert_redirected_to closing_book_url(@closing_book)
  end

  test "should destroy closing_book" do
    assert_difference("ClosingBook.count", -1) do
      delete closing_book_url(@closing_book)
    end

    assert_redirected_to closing_books_url
  end
end
