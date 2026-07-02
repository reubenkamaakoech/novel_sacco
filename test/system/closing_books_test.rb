require "application_system_test_case"

class ClosingBooksTest < ApplicationSystemTestCase
  setup do
    @closing_book = closing_books(:one)
  end

  test "visiting the index" do
    visit closing_books_url
    assert_selector "h1", text: "Closing books"
  end

  test "should create closing book" do
    visit closing_books_url
    click_on "New closing book"

    fill_in "Amount paid", with: @closing_book.amount_paid
    fill_in "Closing date", with: @closing_book.closing_date
    fill_in "Member", with: @closing_book.member_id
    fill_in "Other charges", with: @closing_book.other_charges
    fill_in "Remarks", with: @closing_book.remarks
    fill_in "Total savings", with: @closing_book.total_savings
    fill_in "User", with: @closing_book.user_id
    fill_in "Withdrawal charges", with: @closing_book.withdrawal_charges
    click_on "Create Closing book"

    assert_text "Closing book was successfully created"
    click_on "Back"
  end

  test "should update Closing book" do
    visit closing_book_url(@closing_book)
    click_on "Edit this closing book", match: :first

    fill_in "Amount paid", with: @closing_book.amount_paid
    fill_in "Closing date", with: @closing_book.closing_date
    fill_in "Member", with: @closing_book.member_id
    fill_in "Other charges", with: @closing_book.other_charges
    fill_in "Remarks", with: @closing_book.remarks
    fill_in "Total savings", with: @closing_book.total_savings
    fill_in "User", with: @closing_book.user_id
    fill_in "Withdrawal charges", with: @closing_book.withdrawal_charges
    click_on "Update Closing book"

    assert_text "Closing book was successfully updated"
    click_on "Back"
  end

  test "should destroy Closing book" do
    visit closing_book_url(@closing_book)
    click_on "Destroy this closing book", match: :first

    assert_text "Closing book was successfully destroyed"
  end
end
