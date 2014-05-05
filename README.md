self_systeem
============
| Project                 |  Gem Release      |
|------------------------ | ----------------- |
| Gem name                |  self_systeem      |
| License                 |  [MIT](LICENSE.txt)   |
| Version                 |  [![Gem Version](https://badge.fury.io/rb/self_systeem.png)](http://badge.fury.io/rb/self_systeem) |
| Continuous Integration  |  [![Build Status](https://travis-ci.org/mfpiccolo/self_systeem.png?branch=master)](https://travis-ci.org/mfpiccolo/self_systeem)
| Test Coverage           |  [![Coverage Status](https://coveralls.io/repos/mfpiccolo/self_systeem/badge.png?branch=master)](https://coveralls.io/r/mfpiccolo/self_systeem?branch=coveralls)
| Grade                   |  [![Code Climate](https://codeclimate.com/github/mfpiccolo/self_systeem.png)](https://codeclimate.com/github/mfpiccolo/self_systeem)
| Dependencies            |  [![Dependency Status](https://gemnasium.com/mfpiccolo/self_systeem.png)](https://gemnasium.com/mfpiccolo/self_systeem)
| Homepage                |  [http://mfpiccolo.github.io/self_systeem][homepage] |
| Documentation           |  [http://rdoc.info/github/mfpiccolo/self_systeem/frames][documentation] |
| Issues                  |  [https://github.com/mfpiccolo/self_systeem/issues][issues] |

## Description

###Definition: self-systeem
noun

1.  a realistic respect for or favorable impression of one's system
2.  confidence in one's system worth or abilities
3.  system-respect

Do you have low self-systeem? Don't worry.  This gem is here to help.

self_systeem allows you to record a users interaction with your rails app in a
development enviornment and automatically creates system tests based on the
recordings.

It is simple.  Walk through the app from sart to finish.  Cover as much as you
feel comfortable.  That's it.  You just built a system test.  Congrats!

## Features

After setting up self_systeem (see configuration below) use the generator to create
the system test directory.

`rails g self_systeem:test`

Then run `SELF_SYSTEEM=true rails s`

Now open a new browser preferably in incognito mode so you have fresh session.
Walk through your app like a normal user would.  While you are doing this positive
affirmations are being built in "test/system/support/systeem_booster.yml"

Now just run the test file with `ruby -Itest test/system/systeem_test.rb` and watch
you tests turn green.

## Test Coverage

What do these tests really get you?

Well for one the session and database is persisted while runnin all these tests.
That means that when you are running your tests it is essentially a recreation of
all of those users actions in sequence.

As far as the implementation goes, it is simply a sequence of controller tests that
are strung together and share session data and database data.

There are four assertations that are being called.

1.  Statuses match.
2.  The proper isntance varables are being set.
3.  The instance variable objects match.  (only checks id and _id relationship data for active record objects)
4.  The proper templates are being loaded.

Possitive affirmations:
*  "Today, my system choose to see love instead of fear"
*  "My system possess the qualities needed to be extremely successful"

Feeling better?

Well if those didn't work you can always check out the affirmations that you have built in systeem_booster.yml.  That should do the trick.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "self_systeem"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install self_systeem

## Configuration

To use the generator run:

    $ rails g self_systeem:test

This will set up a system folder under test with a test file and some support files.

Add this line to development.rb

`config.middleware.use "SelfSysteem::AffirmationBuilder" if ENV["SELF_SYSTEEM"].present?`

Temporarily change you database.yml so the development database uses the test database.
This step is only while you build systeem_booster.yml file.  Chage it back when you are done.

i.e.
```ruby
  development: &dev
  adapter: postgresql
  encoding: unicode
  database: app_test # Change this back after creating systeem_booster.yml
  pool: 5
  username: <%= ENV["USER"] %>
  password:
  allow_concurrency: true
  min_messages: warning
```

## The Future

1.  Refactoring would be nice.  2.1 from codeclimate is no good.
2.  Boost test coverage.
3.  Ensure that this works with most setups. Only works with minitest, would be nice to have rspec and several rails versions working.
4.  Make the test database switch automatic when running rails with "SELF_SYSTEEM" env.
5.  Allow more configurable options possibly to allow devs to do more targeted testing post systeem_booster.yml build.
6.  Option to do response body matching of some sort.
7.  Allow for multiple yaml files to be built.
8.  Allow devs to save session and database state to begin a test run. i.e. (For a new file called "create_posts.yml" start with database and session after ["sign_up.yml", "create_profile.yml", "create_blog.yml"])
9.  Open to suggestions.  Lets start boosting that self-systeem!

## Donating
Support this project and [others by mfpiccolo][gittip-mfpiccolo] via [gittip][gittip-mfpiccolo].

[gittip-mfpiccolo]: https://www.gittip.com/mfpiccolo/

## Copyright

Copyright (c) 2013 Mike Piccolo

See [LICENSE.txt](LICENSE.txt) for details.

## Contributing

1. Fork it ( http://github.com/<my-github-username>/self_systeem/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

[![githalytics.com alpha](https://cruel-carlota.pagodabox.com/3d22924e211bdc891d3ad124e085a595 "githalytics.com")](http://githalytics.com/mfpiccolo/self_systeem)

[license]: https://github.com/mfpiccolo/self_systeem/MIT-LICENSE
[homepage]: http://mfpiccolo.github.io/self_systeem
[documentation]: http://rdoc.info/github/mfpiccolo/self_systeem/frames
[issues]: https://github.com/mfpiccolo/self_systeem/issues

