# Open Brewery DB - REST API Server ![Travis CI Build Status](https://travis-ci.org/chrisjm/openbrewerydb-rest-api.svg?branch=master)

The Open Brewery DB API server is a simple Ruby on Rails app connected to a PostgreSQL DB server.

Related project: [Open Brewery DB](https://www.github.com/chrisjm/openbrewerydb-search)

## Main Endpoint

This is the code for the API server running at https://api.openbrewerydb.org/.

[Endpoint Documentation](https://www.openbrewerydb.org/)

## Dependencies

- Ruby 2.4.2
- PostgreSQL
- Elastic Search (See [Searchkick's](https://github.com/ankane/searchkick) [Getting Started](https://github.com/ankane/searchkick#getting-started) section.)

## Run locally

* Clone the repo `$ git clone https://github.com/chrisjm/openbrewerydb-rest-api`
* Run `bundle install`
* Run `bundle exec rails db:setup`
* Run `bundle exec rails s`
* The server will be running at `http://localhost:3000`

**Note: There is no front-end for the API at this time.**

## Seed breweries dataset

Included in the repo at `lib/import/brewers_association/` is scraped HTML from the Brewer's Association. This will be replaced soon with a full compressed SQL which will be easier

`bundle exec rake breweries:import:brewers_association`

## Run tests

`bundle exec rake` or `bundle exec rspec`

