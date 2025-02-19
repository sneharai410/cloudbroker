require "application_system_test_case"

class CloudletsTest < ApplicationSystemTestCase
  setup do
    @cloudlet = cloudlets(:one)
  end

  test "visiting the index" do
    visit cloudlets_url
    assert_selector "h1", text: "Cloudlets"
  end

  test "should create cloudlet" do
    visit cloudlets_url
    click_on "New cloudlet"

    fill_in "File size", with: @cloudlet.file_size
    fill_in "Length", with: @cloudlet.length
    fill_in "Output size", with: @cloudlet.output_size
    fill_in "Workload type", with: @cloudlet.workload_type
    click_on "Create Cloudlet"

    assert_text "Cloudlet was successfully created"
    click_on "Back"
  end

  test "should update Cloudlet" do
    visit cloudlet_url(@cloudlet)
    click_on "Edit this cloudlet", match: :first

    fill_in "File size", with: @cloudlet.file_size
    fill_in "Length", with: @cloudlet.length
    fill_in "Output size", with: @cloudlet.output_size
    fill_in "Workload type", with: @cloudlet.workload_type
    click_on "Update Cloudlet"

    assert_text "Cloudlet was successfully updated"
    click_on "Back"
  end

  test "should destroy Cloudlet" do
    visit cloudlet_url(@cloudlet)
    click_on "Destroy this cloudlet", match: :first

    assert_text "Cloudlet was successfully destroyed"
  end
end
