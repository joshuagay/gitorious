
DESCRIPTION:
===========

just_paginate is a framework-agnostic approach to creating paginated
webpages. It has no external dependencies and works with any web
framework.

Consists of two main methods, paginate and page_navigation.

JustPaginate.paginate helps you slice up your collections and, given a
page number, entities per page and totoal entity count, gives you the
correct range of indexes you need to get. You supply a block where you
specify how elements with those indices are to be gathered. Your block
needs to return those elements. The JustPaginate method then returns
the objects that you sliced in your block, as well as the total number
of pages in the pagination.

JustPaginate.page_navigation generates html for a page-navigator
widget that will let you navigate arbitrarily large page ranges: if
the range is larger than what can be displayed, it truncates the range
of pages. You supply it with current page number, and total number of
pages. You pass in a block which, given the page number, will let you
construct a html link to that page number.

Note: There is also a JustPaginate.page_value helper method that will
take an arbitrary object, and try to translate it to a (default) page
number. If you are using Rails you can simply pass the param
specifying current page and JustPaginate will do its best to translate
it to a page number integer.


EXAMPLES:
======

Say we have a Rails app, with an index page of paginated Projects. You
could do this in the controller, to select the 20 projects for the
current page:

```rb
page = JustPaginate.page_value(params[:page])
project_count = Project.count
projects, total_pages = JustPaginate.paginate(page, 20, project_count) do |index_range|
  Project.all.slice(index_range)
end
```

And in the index.html.erb file, to generate the page navigation:

```erb
<%= JustPaginate.page_navigation(page, total_pages) { |page_no| "/projects/?page=#{page_no}" } -%>
```

INSTALL:
========

```sh
sudo gem install just_paginate
```

Or simply stick just_paginate into your Gemfile and use Bundler to
pull it down.


## License

### The MIT License (MIT)

**Copyright (C) 2013 Gitorious AS**

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
