require "application_system_test_case"

class DocumentsTest < ApplicationSystemTestCase
  setup do
    @document = documents(:one)
  end

  test "visiting the index" do
    visit documents_url
    assert_selector "h1", text: "Documents"
  end

  test "should create document" do
    visit documents_url
    click_on "New document"

    fill_in "Account", with: @document.account_id
    fill_in "Content", with: @document.content
    fill_in "Folder", with: @document.folder_id
    fill_in "Metadata", with: @document.metadata
    fill_in "Status", with: @document.status
    fill_in "Summary", with: @document.summary
    fill_in "User", with: @document.user_id
    click_on "Create Document"

    assert_text "Document was successfully created"
    click_on "Back"
  end

  test "should update Document" do
    visit document_url(@document)
    click_on "Edit this document", match: :first

    fill_in "Account", with: @document.account_id
    fill_in "Content", with: @document.content
    fill_in "Folder", with: @document.folder_id
    fill_in "Metadata", with: @document.metadata
    fill_in "Status", with: @document.status
    fill_in "Summary", with: @document.summary
    fill_in "User", with: @document.user_id
    click_on "Update Document"

    assert_text "Document was successfully updated"
    click_on "Back"
  end

  test "should destroy Document" do
    visit document_url(@document)
    accept_confirm { click_on "Destroy this document", match: :first }

    assert_text "Document was successfully destroyed"
  end
end
