require 'cgi'

class SearchPage
  include Page

  def open(q)
    visit "/search?q=#{CGI.escape(q)}"
  end

  def should_include_results_for(q)
    expect(page).to have_content(q)
  end

end

def search_page
  SearchPage.new
end

