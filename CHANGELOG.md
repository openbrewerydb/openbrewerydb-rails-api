# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Slugs
- Authentication
- Authorization
- Brewery update suggestions feature

## [0.4.1] - 2019-03-07

### Fixed

- Fix Brewery `by_state` filter to be more exact. Note: State abbreviations no longer work

### Removed

- Ahoy analytics tracking
- Unnecessary files

### Changed

- Turned off IP spoofing check

## [0.4.0] - 2018-11-25

### Added

- Brewery tags via ActsAsTaggableOn gem
- This CHANGELOG 🎉

## [0.3.5] - 2018-11-24

### Changed

- Security Issue: rack and loofah
- Updated all gems to the most recent version
- README build icon

## [0.3.4] - 2018-10-18

### Added

- Community documentation for contribution.

### Removed

- CircleCI config

## [0.3.3] - 2018-09-20

### Added

- TravisCI config
- README

## [0.3.2] - 2018-09-08

### Added

- Sentry for error and bug tracking

### Changed

- Redirect homepage to [documentation page](https://www.openbrewerydb.org)

### Removed

- Rollbar because it was going to be \\$\\$\$

## [0.3.1] - 2018-08-24

### Added

- Rollbar for error and bug tracking

## [0.3.0] - 2018-08-23

### Added

- Columns `country`, `longitude`, `latitude` to breweries table
- Attach Geocoder gem to Brewery model
- Task to update all brewery geocodes

### Changed

- Rename breweries table `address` column to `street`

## [0.2.0] - 2018-08-11

### Added

- Search implemented via ElasticSearch and Searchkick gem
- Search endpoint
- Autocomplete endpoint
- Add event tracking via Ahoy Matey gem

### Changed

- Disable Brewery POST, PUT, and DELETE endpoints for now

## 0.1.0 - 2018-06-29

### Added

- Brewery and User models
- Brewery and User CRUD endpoints
- Breweries list endpoint with filtering by city, state, name, type
- Single brewery endpoint
- Pagination and sorting on breweries list
- Take to import breweries based on Brewers Association website scrape
- CircleCI configuration, Rubocop config, robots.txt

[unreleased]: https://github.com/chrisjm/openbrewerydb-api-server/compare/v0.4.1...HEAD
[0.4.1]: https://github.com/chrisjm/openbrewerydb-api-server/compare/v0.4.0...v0.4.1
[0.4.0]: https://github.com/chrisjm/openbrewerydb-api-server/compare/v0.3.5...v0.4.0
[0.3.5]: https://github.com/chrisjm/openbrewerydb-api-server/compare/v0.3.4...v0.3.5
[0.3.4]: https://github.com/chrisjm/openbrewerydb-api-server/compare/v0.3.3...v0.3.4
[0.3.3]: https://github.com/chrisjm/openbrewerydb-api-server/compare/v0.3.2...v0.3.3
[0.3.2]: https://github.com/chrisjm/openbrewerydb-api-server/compare/v0.3.1...v0.3.2
[0.3.1]: https://github.com/chrisjm/openbrewerydb-api-server/compare/v0.3.0...v0.3.1
[0.3.0]: https://github.com/chrisjm/openbrewerydb-api-server/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/chrisjm/openbrewerydb-api-server/compare/v0.1.0...v0.2.0
