![Open Brewery DB Logo](OpenBreweryDBLogo.png)

# 🍻 Official Open Brewery DB REST API Server 

![Github Actions Badge](https://github.com/chrisjm/openbrewerydb-rails-api/workflows/Build%20&%20Test%20Suite/badge.svg)

The Open Brewery DB API server is a Ruby on Rails app connected to a PostgreSQL DB server served at https://api.openbrewerydb.org.

[Documentation](https://www.openbrewerydb.org/)

## 📦 Dependencies

* Ruby 2.6.5
* PostgreSQL 9.4
* Elastic Search (See [Searchkick's](https://github.com/ankane/searchkick) [Getting Started](https://github.com/ankane/searchkick#getting-started) section.) _Note: Elastic Search is likely to be removed in the future._

## 🚀 Getting Started

### Local Environement

1. Clone the repo `$ git clone https://github.com/chrisjm/openbrewerydb-rest-api`
2. Run `bundle install`
3. Run `bundle exec rails db:setup`
4. Run `bundle exec rails s`

The server will be running at `http://localhost:3000`

### Database Expectations

There are some assumptions for the local PostgreSQL service configuration.

- Host is `localhost` or `127.0.0.1`
- User is blank (i.e. it is the current system user)
- Password is blank

All of these settings can be overwritten by setting environment variables in `.env`:

- `POSTGRES_USER`
- `POSTGRES_PASSWORD`
- `POSTGRES_HOST`

See `config/database.yml` for configuration.

### Running Tests

`bundle exec rake` or `bundle exec rspec`

## 🤝 Contributing

For information on contributing to this project, please see the [contributing guide](CONTRIBUTING.md) and our [code of conduct](CODE_OF_CONDUCT.md).

## 🔗 Related

* [Open Brewery DB Website & Documentation](https://github.com/chrisjm/openbrewerydb-gatsby)
* [Open Brewery DB Dataset](https://github.com/openbrewerydb/openbrewerydb)

## 👾 Community

* [Join the Newsletter](http://eepurl.com/dBjS0j)
* [Join the Discord](https://discord.gg/SHtpdEN)

## 📫 Feedback

Any feedback, please [email me](mailto:chris@openbrewerydb.org). 

Cheers! 🍻
