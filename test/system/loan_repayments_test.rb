require "application_system_test_case"

class LoanRepaymentsTest < ApplicationSystemTestCase
  setup do
    @loan_repayment = loan_repayments(:one)
  end

  test "visiting the index" do
    visit loan_repayments_url
    assert_selector "h1", text: "Loan repayments"
  end

  test "should create loan repayment" do
    visit loan_repayments_url
    click_on "New loan repayment"

    fill_in "Amount", with: @loan_repayment.amount
    fill_in "Loan", with: @loan_repayment.loan_id
    fill_in "Member", with: @loan_repayment.member_id
    fill_in "User", with: @loan_repayment.user_id
    click_on "Create Loan repayment"

    assert_text "Loan repayment was successfully created"
    click_on "Back"
  end

  test "should update Loan repayment" do
    visit loan_repayment_url(@loan_repayment)
    click_on "Edit this loan repayment", match: :first

    fill_in "Amount", with: @loan_repayment.amount
    fill_in "Loan", with: @loan_repayment.loan_id
    fill_in "Member", with: @loan_repayment.member_id
    fill_in "User", with: @loan_repayment.user_id
    click_on "Update Loan repayment"

    assert_text "Loan repayment was successfully updated"
    click_on "Back"
  end

  test "should destroy Loan repayment" do
    visit loan_repayment_url(@loan_repayment)
    click_on "Destroy this loan repayment", match: :first

    assert_text "Loan repayment was successfully destroyed"
  end
end
