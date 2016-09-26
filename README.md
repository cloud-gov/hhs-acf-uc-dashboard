# Reporting dashboard for Unaccompanied Children database

[![security](https://hakiri.io/github/18F/hhs-acf-uc-dashboard/master.svg)](https://hakiri.io/github/18F/hhs-acf-uc-dashboard/master) [![Code Climate](https://codeclimate.com/github/18F/hhs-acf-uc-dashboard/badges/gpa.svg)](https://codeclimate.com/github/18F/hhs-acf-uc-dashboard) [![Test Coverage](https://codeclimate.com/github/18F/hhs-acf-uc-dashboard/badges/coverage.svg)](https://codeclimate.com/github/18F/hhs-acf-uc-dashboard/coverage) [![Build Status](https://api.travis-ci.org/18F/hhs-acf-uc-dashboard.svg)](https://api.travis-ci.org/18F/hhs-acf-uc-dashboard.svg)

Unaccompanied children apprehended by the Department of Homeland Security (DHS) immigration officials are transferred to the care and custody of Office of Refugee Resettlement (ORR). ORR promptly places an unaccompanied child in the least restrictive setting that is in the best interests of the child, taking into consideration danger to self, danger to the community, and risk of flight. ORR takes into consideration the unique nature of each child’s situation and incorporates child welfare principles when making placement, clinical, case management, and release decisions that are in the best interest of the child.

More info: [www.acf.hhs.gov/orr/programs/ucs](http://www.acf.hhs.gov/orr/programs/ucs)

This repo will contain a web app used within ORR to view data from their unaccompanied child portal.

## Repositories

- API
- Dashboard (this repo)

## Product Board
Stories are on a [Pivotal Tracker Workspace](https://www.pivotaltracker.com/n/projects/1779875) that is public.

## Application Information

This is a Rails app with authentication covered by the `devise` gem.

Bundling and setting up databases follows the expected Rails patterns.

Tests can be run with the default rake command, `rake`.

## API

This application is built on top of an API, whose staging version is
available at https://hhs-uc-api.apps.cloud.gov.

## Non-Ruby dependencies

Rails uses the `poltergeist` gem for testing, which requires the binary `phantomjs`.
On our mac machines use: `brew install phantomjs`. Otherwise checkout
either project for advice on installation.

## Deploying

A demo application is on [cloud.gov](https://hhs-acf-uc-dashboard.apps.cloud.gov/). With permissions you can deploy with `cf push`. Getting access to the box can be done via `cf-ssh`.

More detailed deployment information is available in [deploy.md](deploy.md).

## Security

The application can be scanned locally via `brakeman`. Currently it is
showing the same warning that Hakiri found, and is hosted.

## Contributing

See [CONTRIBUTING](CONTRIBUTING.md) for additional information.

## Public domain

This project is in the worldwide [public domain](LICENSE.md). As stated in [CONTRIBUTING](CONTRIBUTING.md):

> This project is in the public domain within the United States, and copyright and related rights in the work worldwide are waived through the [CC0 1.0 Universal public domain dedication](https://creativecommons.org/publicdomain/zero/1.0/).
>
> All contributions to this project will be released under the CC0 dedication. By submitting a pull request, you are agreeing to comply with this waiver of copyright interest.
