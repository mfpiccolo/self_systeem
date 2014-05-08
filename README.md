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

## Functionality

This gem can be used in conjunction with TDD or other testing philosophies.

The workflow is as follows:

1.  Configure self_systeem.  (See Configuration below)

2.  Run the rails server with a SYSTEEM env variable.  The value of this variable will be the filename of the affirmation recording.  i.e. `SYSTEEM=some_feature rails s`.  If you would like to add directories just add `/` i.e. `SYSTEEM=registration/signup rails s`

3.  Open a browser in incogneto mode to get a fresh session.

4.  Navigate through the app until the feature you are describing is covered.

5.  Run the tests and watch them turn green.

## Modularity

  self_systeem is set up to allow features to be tested in a modular form.  Each test can require a previous test.  This allows you to only test one particular feature at a time and require the database and session to be at a specific state.

  Here is a modular workflow:

1.  Build a initial affirmation. i.e `SYSTEEM=registration/signup rails s` and sign a user up.  Run the tests to make sure they pass.

2.  Create a yaml file under `test/system/support/affirmations`.  If your applicatiion was a blog you would do some thing like `create_post.yml`

3.  Open your new feature file and paste in:

    ```
    ---
    :requirements:
    - registration/signup
    :affirmations: []
    ```
4.  Run `SYSTEEM=create_post rails s`.  Open an incogneto browser and this will preload your session and database.  That means you can navigate straight to the route you need to without signing in.  It is already taken care of by the requirements.  Complete the feature.

5.  Run the tests to ensure they pass.

6.  Repeat this process until all features have been covered.  Remeber you can require any affirmation so for example you can now create a affirmation to cover blog post comments that requires create_post.

The great thing about this method of testing is you can have multiple starting points.  i.e. (registration/admin_signup, registration/user_signup)
```                                                                      
                   +--------------+    +---------------+                  
                   |              |    |               |                  
                   | admin_signup |    | user_signup   |                  
    passes down    |              |    |               |                  
     db/session    |              |    |               |                  
              +    +------+-------+    +------+--------+                  
              |           |                   |                           
              +-----------+                   |                           
                          |                   |                           
          +---------------+                   +--------------+            
          |               |                   |              |            
          |               |                   |              |            
  +-------+-----+ +-------+-----+    +--------+-----+  +-----+--------+   
  |             | |             |    |              |  |              |   
  |  admin      | |   admin     |    |   user       |  |  user        |   
  | feature_1   | |  feature_2  |    |  feature_1   |  | feature_2    |   
  |             | |             |    |              |  |              |   
  |             | |             |    |              |  |              |   
  +-------------+ +-------------+    +--------------+  +--------------+   
                                                                                                                                               
```

The database and session passing happens both when you create an affirmation and when you run the tests.  Using this structure you can build a tree of feature tests that cover your entire app and follow a realistic flow that users would actually experience.

## Test Coverage

What do these tests really get you?

There are four assertations that are being called for each test.

1.  Statuses match.
2.  The proper isntance varables are being set.
3.  The instance variable objects match.  (only checks id and _id relationship data for active record objects)
4.  The proper templates are being loaded.

The individual test don't mean much more than controller unit tests, but the session and database is persisted while runnin all these tests.
That means that when you are running your tests it is essentially a recreation of all of those users actions in sequence.  These test have the potential of catching a system bug that unit testing might miss.


Possitive affirmations:
*  "Today, my system choose to see love instead of fear"
*  "My system possess the qualities needed to be extremely successful"

Feeling better?

Well if those didn't work you can always check out the affirmations that you have built in the affrimations directory.  That should do the trick.

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

Works with rspec and minitest

1.  Add gem to gemfile and bundle

2.  Add this to config/initializers/systeem.rb
```ruby
    SelfSysteem.configure do |config|
      # uncomment line below if using rspec
      # config.test_framework = "rspec"

      config.test_dir = "spec" # specify directory which you hold your tests
    end
```
3.  Run the generator

    `$ rails g self_systeem:test`

  This will set up a system folder under test or spec with a test file and some support files.

4.  Add this line to development.rb

`config.middleware.use "SelfSysteem::AffirmationBuilder" if ENV["SYSTEEM"].present?`

  Temporarily change you database.yml so the development database uses the test   database.This step is only while you build systeem_booster.yml file.  Chage it back when you are done.

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

1.  Refactoring would be nice.
2.  Boost test coverage.
3.  Ensure that this works with most setups.
4.  Make the test database switch automatic when running rails with "SYSTEEM" env.
5.  Allow more configurable options possibly to allow devs to do more targeted testing post yml build.
6.  Allow config to decide what level of testing is desired. i.e. (assert all attributes on all objects or just ids)
7.  Option to do response body matching of some sort.
8.  Open to suggestions.  Lets start boosting that self-systeem!

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

