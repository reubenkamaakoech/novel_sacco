require "test_helper"

class LoansControllerTest < ActionDispatch::IntegrationTest
  setup do
    @loan = loans(:one)
  end

  test "should get index" do
    get loans_url
    assert_response :success
  end

  test "should get new" do
    get new_loan_url
    assert_response :success
  end

  test "should create loan" do
    assert_difference("Loan.count") do
      post loans_url, params: { loan: { amount: @loan.amount, available_amount: @loan.available_amount, member_id: @loan.member_id, payment_period_months: @loan.payment_period_months, repayment_amount_per_month: @loan.repayment_amount_per_month } }
    end

    assert_redirected_to loan_url(Loan.last)
  end

  test "should show loan" do
    get loan_url(@loan)
    assert_response :success
  end

  test "should get edit" do
    get edit_loan_url(@loan)
    assert_response :success
  end

  test "should update loan" do
    patch loan_url(@loan), params: { loan: { amount: @loan.amount, available_amount: @loan.available_amount, member_id: @loan.member_id, payment_period_months: @loan.payment_period_months, repayment_amount_per_month: @loan.repayment_amount_per_month } }
    assert_redirected_to loan_url(@loan)
  end

  test "should destroy loan" do
    assert_difference("Loan.count", -1) do
      delete loan_url(@loan)
    end

    assert_redirected_to loans_url
  end
end
