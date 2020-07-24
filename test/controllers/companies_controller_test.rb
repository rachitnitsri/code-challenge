require "test_helper"
require "application_system_test_case"

class CompaniesControllerTest < ApplicationSystemTestCase

  def setup
    @company = companies(:hometown_painting)
  end

  test "Index" do
    visit companies_path

    assert_text "Companies"
    assert_text "Hometown Painting"
    assert_text "Wolf Painting"
  end

  test "Show" do
    visit company_path(@company)

    assert_text @company.name
    assert_text @company.phone
    assert_text @company.email
    assert_text @company.city
    assert_text @company.state
  end

  test "Update" do
    visit edit_company_path(@company)

    within("form#edit_company_#{@company.id}") do
      fill_in("company_name", with: "Updated Test Company")
      fill_in("company_zip_code", with: "93009")
      fill_in("company_email", with: "update_test_company@getmainstreet.com")
      click_button "Update Company"
    end

    assert_text "Changes Saved"

    @company.reload
    assert_equal "Updated Test Company", @company.name
    assert_equal "93009", @company.zip_code
    assert_equal "Ventura", @company.city
    assert_equal "California", @company.state
  end

  test "Create" do
    visit new_company_path

    within("form#new_company") do
      fill_in("company_name", with: "New Test Company")
      fill_in("company_zip_code", with: "93009")
      fill_in("company_phone", with: "5553335555")
      fill_in("company_email", with: "new_test_company@getmainstreet.com")
      click_button "Create Company"
    end

    assert_text "Saved"

    last_company = Company.last
    assert_equal "New Test Company", last_company.name
    assert_equal "93009", last_company.zip_code
    assert_equal "Ventura", last_company.city
    assert_equal "California", last_company.state
  end

  test "Destroy" do
    visit companies_path
    count_companies_before_deletion = Company.count
    visit company_path(@company)
    accept_alert do
      click_link "Delete"
    end
    @company.reload
    assert_text "Company deleted successfully"
    count_companies_after_deletion = Company.count
    assert_equal count_companies_after_deletion, count_companies_before_deletion - 1
  end

  test "Should show invalid email while creating new company" do
    visit new_company_path

    within("form#new_company") do
      fill_in("company_name", with: "New Test Company")
      fill_in("company_zip_code", with: "93009")
      fill_in("company_phone", with: "5553335555")
      fill_in("company_email", with: "new_test_company@getma.com")
      click_button "Create Company"
    end

    assert_text "Provided email address must end with @getmainstreet.com domain"
  end

  test "Should show invalid email while updating company" do
    visit edit_company_path(@company)

    within("form#edit_company_#{@company.id}") do
      fill_in("company_name", with: "Updated Test Company")
      fill_in("company_email", with: "update_test_company@getma.com")
      click_button "Update Company"
    end
    
    assert_text "Provided email address must end with @getmainstreet.com domain"
  end

  test "Should not show invalid email while updating company with blank email" do
    visit edit_company_path(@company)

    within("form#edit_company_#{@company.id}") do
      fill_in("company_name", with: "Updated Test Company")
      fill_in("company_email", with: "")
      click_button "Update Company"
    end
    
    assert_text "Changes Saved"
  end

  test "Should ask for update with valid zip_code if given invalid on new company creation" do
    visit new_company_path

    within("form#new_company") do
      fill_in("company_name", with: "New Test Company")
      fill_in("company_zip_code", with: "ABCD")
      fill_in("company_phone", with: "5553335555")
      fill_in("company_email", with: "new_test_company@getmainstreet.com")
      click_button "Create Company"
    end

    assert_text "Saved"

    last_company = Company.last
    visit company_path(last_company)

    assert_equal "New Test Company", last_company.name
    assert_equal "ABCD", last_company.zip_code
    assert_nil last_company.city
    assert_nil last_company.state
    assert_text "Update with valid zip code to get City and State here"
  end

  test "Should ask for update with valid zip_code if given invalid on updation" do
    visit edit_company_path(@company)

    within("form#edit_company_#{@company.id}") do
      fill_in("company_name", with: "Updated Test Company")
      fill_in("company_zip_code", with: "ABCD")
      fill_in("company_email", with: "update_test_company@getmainstreet.com")
      click_button "Update Company"
    end

    assert_text "Changes Saved"

    @company.reload
    visit company_path(@company.id)

    assert_equal "Updated Test Company", @company.name
    assert_equal "ABCD", @company.zip_code
    assert_nil @company.city
    assert_nil @company.state
    assert_text "Update with valid zip code to get City and State here"
  end

end
