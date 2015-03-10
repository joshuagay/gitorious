# Gitorious Smoke Tests

This repository contains a set of smoke tests used to validate Gitorious builds.

## Installation

1. Install poltergeist

2. Install dependencies
```
bundle install
```

## Usage

1. Start Gitorious instance (`https://gitorious.local`)

2. Create an user (`test`/`test123`)

  * Manually

  * Or with `GTS\_USER="test" GTS\_PASS="test123" bin/create-user deploy@gitorious.local`

3. Run the specs
```
GTS\_HOST="https://gitorious.local" GTS\_USER=test GTS\_PASS=test123 bundle exec rspec
```

### Notes

You need to create first user manually, because public registration is not enabled by default.

It is safe to run the tests against the same user multiple times, as new keys are generated on each run.

### Defaults for specs and bin/create-user:

 * GTS\_HOST: `http://vagrant`

 * GTS\_USER: `test`

 * GTS\_PASS: `testest`

