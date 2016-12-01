[![Join the chat at https://gitter.im/webdev-camp/laser](https://badges.gitter.im/webdev-camp/laser.svg)](https://gitter.im/webdev-camp/laser?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
[![Build Status](https://travis-ci.org/webdev-camp/laser.svg?branch=master)](https://travis-ci.org/webdev-camp/laser)
[![Code Climate](https://codeclimate.com/github/webdev-camp/laser/badges/gpa.svg)](https://codeclimate.com/github/webdev-camp/laser)
[![Test Coverage](https://codeclimate.com/github/webdev-camp/laser/badges/coverage.svg)](https://codeclimate.com/github/webdev-camp/laser/coverage)

## Laser: Another Search Engine for Ruby

Gems make the developers life easier. But finding the right one can be a challenge.
Laser was created to help with just that.
With searchable text and tags, you will find the Gem you need in no time.

This is an open source project, so everyone can contribute and make it better. The project
was started by the first cohort at [Web Dev Camp](http://webdev.camp), and continues to
be maintained and hosted by Web Dev Camp, to allow the ruby community to influence their
own tools.

Due to limited time on the course, feature prioritisation had to take place. Since the
release of the first version, work continues, and **contribution are welcome.**

## Features

Data is aggregated from rubygems.org and github.com. Some features are not available for
gems not hosted on github.

- List Gems by rank, download , forks, watchers
- Search full text on name and description
- search by tag (exact)
- gem views including activity data
- similar gem list (by same tag)
- per gem comment
- gem tagging
- gem ranking

## Technology

Laser is a relatively standard rails application. It uses HAML as template engine and SASS
for CSS generation. Devise is used for authentication and ransack for searching. Rspec
is used for testing and guard is set up for those who enjoy tdd.

As you can see by the badges, we have travis set up to check the tests and codeclimate
to keep us on the straight and narrow.

## Contributing to rubylaser

- Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
- Fork the project
- Start a feature/bugfix branch (unless it's a tiny fix)
- Commit and push until you are happy with your contribution (and tests pass)
- Make sure to add rpsec tests for it. Patches or features without tests will be rejected.

Reach us by [gitter](https://gitter.im/webdev-camp/laser)
