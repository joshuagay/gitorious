# Tiltout

<a href="http://travis-ci.org/cjohansen/tiltout" class="travis">
  <img src="https://secure.travis-ci.org/cjohansen/tiltout.png">
</a>

## Tilt templates with layouts and helpers

Tiltout is a small abstraction over Tilt that allows you to render templates
with some additional conveniences:

* Layouts
* Helper modules
* Caching

## Overview

Let's say we have a template, `~/projects/tiltout/templates/greet.erb`:

```rhtml
<h1><%= @title = greet("Hey", name) %></h1>
```

And another template, `~/projects/tiltout/templates/layout.erb`:

```rhtml
<!DOCTYPE html>
<html>
  <head>
    <title><%= @title %></title>
  </head>
  <body>
    <%= yield %>
  </body>
</html>
```

Then the following code:

```ruby
require "tiltout"

module Greeter
  def greet(greeting, name)
    "#{greeting} #{name}!"
  end
end

out = Tiltout.new("~/projects/tiltout/templates", :layout => "layout")
out.helper(Greeter, { :name => "Chris" })
html = out.render(:greet)
```

Will produce the following HTML:

```html
<!DOCTYPE html>
<html>
  <head>
    <title>Hey Chris!</title>
  </head>
  <body>
    <h1>Hey Chris!</h1>
  </body>
</html>
```

## Layouts

`Tiltout` can be instantiated with a default layout that will be used for every
template. You can also optionally override the layout for each individual
template to render.

Layouts are rendered with the same context as templates, and are rendered after
the template itself. This means that you can set instance variables in the
template that can be used in the layout (useful for e.g. extra head data, title
etc).

Templates are included in the layout where the layout `yield`s, e.g.:

```rhtml
<!DOCTYPE html>
<html>
  <head>
    <title><%= @title %></title>
  </head>
  <body>
    <%= yield %>
  </body>
</html>
```

Given the following template:

```rhtml
<h1><%= @title = "Hey!" %></h1>
```

The following output would be produced:

```html
<!DOCTYPE html>
<html>
  <head>
    <title>Hey!</title>
  </head>
  <body>
    <h1>Hey!</h1>
  </body>
</html>
```

## Helper modules

`Tiltout` provides a convenient API for registering modules that are included in
the rendering context so you can call the module's methods as "helpers" from
your templates:

```rhtml
<!-- greet.erb -->
<h1>Hey <%= snake_case(name) %></h1>
```

```ruby
require "tiltout"

module SnakeCaser
  def snake_case(text)
    text.gsub(/(.)([A-Z])/,'\1_\2').downcase
  end
end

out = Tiltout.new("path/to/templates")
out.helper(SnakeCaser)

out.render(:greet, { :name => "ChrisJohansen" })
#=> "<h1>Hey chris_johansen</h1>"
```

## Caching

By default, `Tiltout` will cache your templates after reading them from file the
first time. If you don't want caching - say because you're actively developing
the template - you simply disable it when instantiating your `Tiltout` instance:

```ruby
out = Tiltout.new("path/to/templates", :cache => false)
```

## Installing

`tiltout` ships as a gem:

    $ gem install tiltout

Or in your Gemfile:

    gem "tiltout", "~> 1.0.0"

## Contributing

Contributions are welcome. To get started:

    $ git clone git://gitorious.org/gitorious/tiltout.git
    $ cd tiltout
    $ bundle install
    $ rake

When you have fixed a bug/added a feature/done your thing, create a
[clone on Gitorious](http://gitorious.org/gitorious/tiltout) or a
[fork on GitHub](http://github.com/cjohansen/tiltout) and send a
merge request/pull request, whichever you prefer.

Please add tests when adding/altering code, and always make sure all the tests
pass before submitting your contribution.

## License

### The MIT License (MIT)

**Copyright (C) 2012 Gitorious AS**

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
