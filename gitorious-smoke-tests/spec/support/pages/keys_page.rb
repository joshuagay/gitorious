class KeysPage
  include Page

  def upload_public_key(key)
    visit "/~#{USER}/keys/new"

    fill_in "ssh_key_key", with: key.public
    click_button "Save"
  end
end

def keys_page
  KeysPage.new
end
