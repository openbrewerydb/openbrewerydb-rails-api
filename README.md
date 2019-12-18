# Open Brewery DB - REST API Server ![Travis CI Build Status](https://travis-ci.org/chrisjm/openbrewerydb-api-server.svg?branch=master)

The Open Brewery DB API server is a Ruby on Rails API app connected to a PostgreSQL DB server.

Related project: [Open Brewery DB](https://www.github.com/chrisjm/openbrewerydb-search)

## Description

This is the code for the [Open Brewery DB API server](https://api.openbrewerydb.org/).

[Documentation](https://www.openbrewerydb.org/)

## Dependencies

- Ruby 2.6.5
- PostgreSQL 9.4
- Elastic Search (See [Searchkick's](https://github.com/ankane/searchkick) [Getting Started](https://github.com/ankane/searchkick#getting-started) section.)

## Run locally

- Clone the repo `$ git clone https://github.com/chrisjm/openbrewerydb-rest-api`
- Run `bundle install`
- Run `bundle exec rails db:setup`
- Run `bundle exec rails s`
- The server will be running at `http://localhost:3000`

**Note: There is no front-end for the API at this time.**

## Database setup

There are some assumptions for the local PostgreSQL service configuration.

- Host is `localhost` or `127.0.0.1`
- User is blank (i.e. it is the current system user)
- Password is blank

All of these settings can be overwritten by setting environment variables in `.env`:

- `POSTGRES_USER`
- `POSTGRES_PASSWORD`
- `POSTGRES_HOST`

See `config/database.yml` for configuration.

## Seed breweries dataset

Included in the repo at `lib/import/brewers_association/` is scraped HTML from the Brewer's Association. This will be replaced soon with a full compressed SQL which will be easier

`bundle exec rake breweries:import:brewers_association`

## Run tests

`bundle exec rake` or `bundle exec rspec`
