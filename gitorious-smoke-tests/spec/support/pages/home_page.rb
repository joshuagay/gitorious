require 'open-uri'

class HomePage
  include Page

  def open
    visit "/"
  end

  def should_include_valid_css_urls
    all('link[rel=stylesheet]', visible: false).each do |link|
      should_include_valid_url(link[:href])
    end
  end

  def should_include_valid_js_urls
    all('script[src]', visible: false).each do |script|
      should_include_valid_url(script[:src])
    end
  end

  private

  def should_include_valid_url(url)
    url = "#{HOST}#{url}" if url[0] == '/'

    lambda do
      Kernel::open(url).read
    end.should_not raise_error
  end

end

def home_page
  HomePage.new
end
