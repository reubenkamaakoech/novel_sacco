require "application_system_test_case"

class MembersTest < ApplicationSystemTestCase
  setup do
    @member = members(:one)
  end

  test "visiting the index" do
    visit members_url
    assert_selector "h1", text: "Members"
  end

  test "should create member" do
    visit members_url
    click_on "New member"

    fill_in "Email", with: @member.email
    fill_in "Id number", with: @member.id_number
    fill_in "Join date", with: @member.join_date
    fill_in "Membership number", with: @member.membership_number
    fill_in "Name", with: @member.name
    fill_in "Next of kin contact", with: @member.next_of_kin_contact
    fill_in "Next of kin name", with: @member.next_of_kin_name
    fill_in "Phone number", with: @member.phone_number
    check "Status" if @member.status
    click_on "Create Member"

    assert_text "Member was successfully created"
    click_on "Back"
  end

  test "should update Member" do
    visit member_url(@member)
    click_on "Edit this member", match: :first

    fill_in "Email", with: @member.email
    fill_in "Id number", with: @member.id_number
    fill_in "Join date", with: @member.join_date
    fill_in "Membership number", with: @member.membership_number
    fill_in "Name", with: @member.name
    fill_in "Next of kin contact", with: @member.next_of_kin_contact
    fill_in "Next of kin name", with: @member.next_of_kin_name
    fill_in "Phone number", with: @member.phone_number
    check "Status" if @member.status
    click_on "Update Member"

    assert_text "Member was successfully updated"
    click_on "Back"
  end

  test "should destroy Member" do
    visit member_url(@member)
    click_on "Destroy this member", match: :first

    assert_text "Member was successfully destroyed"
  end
end
