# ForceUtf8

ForceUtf8 is a library that allows you to convert any Ruby string into a string encoded in UTF-8. It replaces any unknown characters with question marks.

## Installation

Add this line to your application's Gemfile:

    gem 'force_utf8'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install force_utf8

## Usage

### Monkey-patched version

    require 'force_utf8'

    "foo\xCFbar".force_utf8 # returns "foo?bar"
    "foo\xCFbar".force_utf8! # mutates string into "foo?bar"

### Global function

    require 'force_utf8/encode'

    ForceUtf8::Encode.encode("foo\xCFbar") # returns "foo?bar"
    ForceUtf8::Encode.encode!("foo\xCFbar") # mutates string into "foo?bar"

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Merge Request
