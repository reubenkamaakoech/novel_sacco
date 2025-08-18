require "application_system_test_case"

class LoansTest < ApplicationSystemTestCase
  setup do
    @loan = loans(:one)
  end

  test "visiting the index" do
    visit loans_url
    assert_selector "h1", text: "Loans"
  end

  test "should create loan" do
    visit loans_url
    click_on "New loan"

    fill_in "Amount", with: @loan.amount
    fill_in "Available amount", with: @loan.available_amount
    fill_in "Member", with: @loan.member_id
    fill_in "Payment period months", with: @loan.payment_period_months
    fill_in "Repayment amount per month", with: @loan.repayment_amount_per_month
    click_on "Create Loan"

    assert_text "Loan was successfully created"
    click_on "Back"
  end

  test "should update Loan" do
    visit loan_url(@loan)
    click_on "Edit this loan", match: :first

    fill_in "Amount", with: @loan.amount
    fill_in "Available amount", with: @loan.available_amount
    fill_in "Member", with: @loan.member_id
    fill_in "Payment period months", with: @loan.payment_period_months
    fill_in "Repayment amount per month", with: @loan.repayment_amount_per_month
    click_on "Update Loan"

    assert_text "Loan was successfully updated"
    click_on "Back"
  end

  test "should destroy Loan" do
    visit loan_url(@loan)
    click_on "Destroy this loan", match: :first

    assert_text "Loan was successfully destroyed"
  end
end
