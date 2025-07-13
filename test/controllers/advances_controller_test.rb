require "test_helper"

class AdvancesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @advance = advances(:one)
  end

  test "should get index" do
    get advances_url
    assert_response :success
  end

  test "should get new" do
    get new_advance_url
    assert_response :success
  end

  test "should create advance" do
    assert_difference("Advance.count") do
      post advances_url, params: { advance: { amount: @advance.amount, date: @advance.date, employee_id: @advance.employee_id } }
    end

    assert_redirected_to advance_url(Advance.last)
  end

  test "should show advance" do
    get advance_url(@advance)
    assert_response :success
  end

  test "should get edit" do
    get edit_advance_url(@advance)
    assert_response :success
  end

  test "should update advance" do
    patch advance_url(@advance), params: { advance: { amount: @advance.amount, date: @advance.date, employee_id: @advance.employee_id } }
    assert_redirected_to advance_url(@advance)
  end

  test "should destroy advance" do
    assert_difference("Advance.count", -1) do
      delete advance_url(@advance)
    end

    assert_redirected_to advances_url
  end
end
