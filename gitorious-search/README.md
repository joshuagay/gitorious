# Gitorious::Search

This is a WIP, extracting search functionality from Gitorious into a
separate gem. Apart from this allowing us to actually build a search
API instead of marrying ThinkingSphinx, this should let us use
different versions of ThinkingSphinx based on the current Ruby
version (TS 3.x doesn't support Ruby 1.8).

## Functionality

There's a Railtie in lib/gitorious/search.rb which loads a
compatibility index definition for legacy TS versions. Newer TS
versions will automatically add `app/indices` to the Rails load path,
so these files should be silently ignored by legacy TS versions.

The next step would be to extract actual searches, as used in
`app/controllers/searches_controller.rb` in Gitorious
mainline. We could also provide other search backends in here, which
could make a lot of sense. However:

## Problems with this approach

Removing `thinking_sphinx` and adding `gitorious-search` into
mainline's Gemfile will add a dependency on either 2.x or 3.x of
Thinking Sphinx into Gemfile.lock in mainline. This means that:

- we would need to ensure that `bundle` is run with Ruby 1.9 before
  adding Gemfile.lock to Git
- Ruby 1.8 users would need to either ignore Gemfile.lock or
  regenerate it locally.

This gem has not been pushed to rubygems.org until we decide how to
deal with this.
