# Zuul: The Gitorious gatekeeper (aka API)

Zuul is a stand-alone application that serves an HTTP Hypermedia API for
interacting with Gitorious. It speaks the Hypermedia Application Language (HAL):
http://stateless.co/hal_specification.html
http://tools.ietf.org/html/draft-kelly-json-hal-05

Simply stated, HAL specifies how to embed links in resource payloads for XML and
JSON. Zuul only uses JSON.

Zuul also uses JSON schema to describe the payloads it serves and accepts,
though clients are not specifically required to do anything with them. The
schemas are provided first and foremost as a formal type of documentation.

# Browsing the API

Zuul bundles the HAL browser, which is useful to manually explore the API and
read documentation and JSON schemas. Visit it starting the application (see
below) and visit http://localhost:9292/browser/

# Running the application

Zuul depends on Gitorious 3.x (currently the next branch). In order to run Zuul
with the Gitorious application loaded, you need to start it with Bundler, using
Gitorious' Gemfile. The reason for this is that you're loading the Gitorious
application within Zuul, thus depending on gems that are not required to run
e.g. Zuul's tests.

    $ env GITORIOUS_HOME=/path/to/gitorious3 \
        BUNDLE_GEMFILE=$GITORIOUS_HOME/Gemfile \
        bundle exec rackup -Ilib

You can also start Zuul from `GITORIOUS_HOME`:

    $ env GITORIOUS_HOME=. \
        bundle exec rackup /path/to/zuul/config.ru -I/path/to/zuul/lib

There's a script that automates these that can be run like this:

    $ /path/to/zuul/run $DIR

Where $DIR is the path to your Gitorious 3 installation. There is no need for
Gitorious to actually be running in order to run Zuul.

# Architecture

Zuul is a Sinatra application. However, to avoid bloat, each API endpoint/action
is implemented as a separate endpoint class. These are found in
`lib/zuul/endpoint/*.rb`. The endpoints are associated with URLs and HTTP verbs
through the `config/routes.rb` file. This file typically wires together endpoint
objects with URL patterns/HTTP verbs and dependencies from Gitorious. This file
is the only file that should refer to global Gitorious classes (this way, all
endpoints etc can be tested without loading the Gitorious application).

Endpoints return outcomes as defined by the `use_case` gem where the success is
often wrapped in a serializer. Serializers live in `lib/zuul/serializer/*.rb`
and specify how model objects are converted to hashes, what their links are and
how URLs to these resources are generated. The hash is converted to JSON by the
application.
