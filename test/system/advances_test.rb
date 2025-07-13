require "application_system_test_case"

class AdvancesTest < ApplicationSystemTestCase
  setup do
    @advance = advances(:one)
  end

  test "visiting the index" do
    visit advances_url
    assert_selector "h1", text: "Advances"
  end

  test "should create advance" do
    visit advances_url
    click_on "New advance"

    fill_in "Amount", with: @advance.amount
    fill_in "Date", with: @advance.date
    fill_in "Employee", with: @advance.employee_id
    click_on "Create Advance"

    assert_text "Advance was successfully created"
    click_on "Back"
  end

  test "should update Advance" do
    visit advance_url(@advance)
    click_on "Edit this advance", match: :first

    fill_in "Amount", with: @advance.amount
    fill_in "Date", with: @advance.date
    fill_in "Employee", with: @advance.employee_id
    click_on "Update Advance"

    assert_text "Advance was successfully updated"
    click_on "Back"
  end

  test "should destroy Advance" do
    visit advance_url(@advance)
    click_on "Destroy this advance", match: :first

    assert_text "Advance was successfully destroyed"
  end
end
